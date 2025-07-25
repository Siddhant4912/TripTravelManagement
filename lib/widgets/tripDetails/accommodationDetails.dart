import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accommodationdetails extends StatefulWidget {
  final String? tripId;

  const Accommodationdetails({required this.tripId, Key? key})
      : super(key: key);

  @override
  State<Accommodationdetails> createState() => _AccommodationdetailsState();
}

class _AccommodationdetailsState extends State<Accommodationdetails> {
  // Controllers for text fields
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addNoteController = TextEditingController();
  String user_id = "";

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Fetch user ID from shared preferences
  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString("user_id") ?? "";
    });
    print("User ID: $user_id"); // Debugging
  }

  // Function to show a date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now, // Prevent past dates
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: now,
        end: now.add(const Duration(days: 1)),
      ),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.start.day}/${picked.start.month}/${picked.start.year} - "
            "${picked.end.day}/${picked.end.month}/${picked.end.year}";
      });
    }
  }

  // Function to add accommodation
  Future<void> _addAccommodation() async {
    if (_hotelNameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _addNoteController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Need to Fill All Details",
        backgroundColor: Colors.red,
      );
      return;
    }
    if (widget.tripId == null) {
      Fluttertoast.showToast(
        msg: "Error: Trip ID is missing",
        backgroundColor: Colors.red,
      );
      return;
    }

    print("Trip ID: ${widget.tripId}");

    var signupUrl = Uri.parse(
        conn+"/MyTrips/create_accommodation.php");

    var response = await http.post(signupUrl, body: {
      "trip_id": widget.tripId.toString(),
      "hotel_name": _hotelNameController.text,
      "checkin_checkout_date": _dateController.text,
      "add_note": _addNoteController.text,
      "user_id": user_id.toString(),
    });

    print("Response: ${response.body}");
    var decodedData = json.decode(response.body);

    if (decodedData['status'] == 'data inserted') {
      Fluttertoast.showToast(
        msg: "Accommodation added successfully!",
        backgroundColor: Colors.green,
      );

      // ✅ **Clear TextFields After Successful Insert**
      setState(() {
        _hotelNameController.clear();
        _dateController.clear();
        _addNoteController.clear();
      });
      Navigator.pop(context); // Close the bottom sheet
    } else {
      Fluttertoast.showToast(
        msg: decodedData['status'],
        backgroundColor: Colors.red,
      );
    }
  }

  // Function to show bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Add Accommodation",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),

                // Hotel Name Input
                TextField(
                  controller: _hotelNameController,
                  decoration: InputDecoration(
                    labelText: "Hotel Name",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon:
                        const Icon(Icons.location_on, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Date Picker Input
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: "Check-in / Check-out Date",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Note Input
                TextField(
                  controller: _addNoteController,
                  decoration: InputDecoration(
                    labelText: "Add Note",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.note_alt_outlined,
                        color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    _addAccommodation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _accommodation_details_page() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Accommodation_details_page(
                  trip_id: widget.tripId.toString(),
                  selectedExpenseId: '',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _accommodation_details_page();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0,left: 8.0, right: 8.0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff0a1215),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.bed_rounded,
                              color: Color(0xFFFF66B2)),
                          const SizedBox(width: 10),
                          const Text("Accommodation",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 0.8, top: 15, bottom: 15, right: 15),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF1a2a29),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(0xFF01a686),
                                size: 10,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _showBottomSheet,
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFF0a1927),
                              child: Icon(Icons.add, color: Color(0xFFae15f8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Accommodation_details_page extends StatefulWidget {
  final String trip_id; // Ensure trip_id is a string
  final String selectedExpenseId;

  Accommodation_details_page(
      {Key? key, required this.trip_id, required this.selectedExpenseId})
      : super(key: key);

  @override
  State<Accommodation_details_page> createState() =>
      _Accommodation_details_pageState();
}

class _Accommodation_details_pageState
    extends State<Accommodation_details_page> {
  List<Map<String, dynamic>> accommodation_list = [];
  bool isLoading = true;
  String errorMessage = "";
  String? _selectedDate;
  String selectedAccommodationId = "";

  // Controllers to show selected expense details
  final TextEditingController _categoryController = TextEditingController();
  // final TextEditingController _dateController= TextEditingController();
  final TextEditingController _addNoteController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now, // Prevent past dates
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: now,
        end: now.add(const Duration(days: 1)),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate =
            "${picked.start.day}/${picked.start.month}/${picked.start.year} - "
            "${picked.end.day}/${picked.end.month}/${picked.end.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAccommodation_list();
    // getTotalSpent();
  }

// Calculate total spent amount
  // double getTotalSpent() {
  //   return expenses.fold(0, (sum, item) {
  //     double amount =
  //         double.tryParse(item["how_much_paid"].replaceAll("₹", "").trim()) ??
  //             0.0;
  //     return sum + amount;
  //   });
  // }
Future<void> fetchAccommodation_list() async {
  final String url =
      (conn+"/MyTrips/fetch_accommodation_details.php?trip_id=${widget.trip_id}");

  try {
    final response = await http.get(Uri.parse(url));
    // print("🔄 Response Status: ${response.statusCode}");
    // print("📜 Raw Response Body: ${response.body}");
  if (response.body.trim().isEmpty) {
        // If response is empty, treat it as no data available
        setState(() {
          accommodation_list = [];
          isLoading = false;
          errorMessage = "No Data Available";
        });
        // print("🚨 No accommodation data available!");
        return;
      }
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        accommodation_list = data.map((item) => {
              "accommodation_id": item["accommodation_id"] ?? "unknown",
              "hotel_name": item["hotel_name"] ?? "Unknown",
              "checkin_checkout_date":
                  "${item["checkin_checkout_date"] ?? "0"}",
              "add_note": item["add_note"] ?? "N/A",
            }).toList();

        isLoading = false;
        errorMessage = accommodation_list.isEmpty ? "No Data Available" : "";
      });

      if (accommodation_list.isEmpty) {
        print("🚨 No accommodation data available!");
      }
    } else {
      setState(() {
        errorMessage = "Failed to load data";
        isLoading = false;
      });
    }
  } catch (error) {
    setState(() {
      errorMessage = "Error fetching data: $error";
      isLoading = false;
    });
  }
}

  _update_accommodation(accommodation_ID) async {
    var updateUrl = Uri.parse(
        conn+"/MyTrips/update_accommodation.php");

    var res = await http.post(
      updateUrl,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "accommodation_id": accommodation_ID,
        "hotel_name": _categoryController.text,
        "add_note": _addNoteController.text,
        "checkin_checkout_date": _selectedDate,
      },
    );
    var decodedData = json.decode(res.body);

    if (decodedData['status'] == 'Expense updated successfully') {
      Fluttertoast.showToast(
        msg: "Expense updated successfully!",
        backgroundColor: Colors.green,
      );

      fetchAccommodation_list();
    } else {
      Fluttertoast.showToast(
        msg: decodedData['status'],
        backgroundColor: Colors.red,
      );
    }
  }

  _delete_accommodation(accommodation_ID) async {
    var deleteUrl = Uri.parse(
        conn+"/MyTrips/delete_accommodation.php" //  Correct endpoint
        );

    try {
      var res = await http.post(
        deleteUrl,
        // headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "accommodation_id": accommodation_ID.toString(),
        },
      );

      var decodedData = json.decode(res.body);

      if (decodedData.containsKey("success")) {
        //  Correct success check

        Fluttertoast.showToast(
          msg: "Accommodation Deleted successfully!",
          backgroundColor: Colors.green,
        );

         fetchAccommodation_list(); // R
      } else {
        Fluttertoast.showToast(
          msg: decodedData['error'] ?? "Failed to delete Accommodation",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      // print("⚠️ Error deleting Accommodation: $e");
      Fluttertoast.showToast(
        msg: "⚠️ Network error! Please try again.",
        backgroundColor: Colors.red,
      );
    }
  }

  void _showBottomSheet(Map<String, dynamic> accommodation, accommodation_ID) {
    // Set the selected expense details in text fields
    // print("id fpound"+expense_id);
    _categoryController.text = accommodation["hotel_name"];
    _selectedDate = accommodation["checkin_checkout_date"];
    _addNoteController.text = accommodation["add_note"];
    selectedAccommodationId = accommodation["accommodation_id"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("hello",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),

                // Category Input
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: "Hotel Name",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.category, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Amount Input

                // Date Input
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate ?? "Select a date",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _addNoteController,
                  decoration: InputDecoration(
                    labelText: "Add Note",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon:
                        const Icon(Icons.note_add_outlined, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Update expense logic here
                    // var accommodation_ID = expense["accommodation_id"];
                    _update_accommodation(accommodation_ID);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      const Text("Save", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
                foregroundColor: Colors.white,

        backgroundColor: Colors.black,
        title: const Text("Accommodation Details",
            style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : FutureBuilder(
                  future: fetchAccommodation_list(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                      
                          // Table Header
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.grey[900],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                    child: Text("Hotel Name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text("Date",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text("Note",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          // Expandable List
                          Expanded(
                            child: ListView.builder(
                              itemCount: accommodation_list.length,
                              itemBuilder: (context, index) {
                                final accommodation = accommodation_list[index];
                                return Card(
                                  color: Colors.grey[850],
                                  child: GestureDetector(
                                    onTap: () {
                                      var accommodation_ID = accommodation['accommodation_id'];
                                      print(accommodation_ID);
                                      _showBottomSheet(accommodation, accommodation_ID);
                                    },
                                    child: Container(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    accommodation["hotel_name"],
                                                    style: const TextStyle(
                                                        color: Colors.white))),
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                  size: 20,
                                                  color: Colors.greenAccent,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      accommodation[
                                                          "checkin_checkout_date"],
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .greenAccent)),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                                child: Text(accommodation["add_note"],
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .greenAccent))),
                                            GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Confirm Deletion"),
                                                        content: Text(
                                                            "Are you sure you want to delete this item?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                               var accommodation_ID = accommodation['accommodation_id'];

                                                                Navigator.of(context)
                                                                    .pop();

                                                                    _delete_accommodation(accommodation_ID);
                                                            },
                                                            child: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),


                  
                  // Add Floating Action Button
  // floatingActionButton: FloatingActionButton(
  //   backgroundColor: Colors.greenAccent,
  //   onPressed: () {
  //     // _showCreateExpenseDialog();
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //       builder: (context) => CreateExpensePage(tripId: widget.trip_id,)));
     

  //   },
  //   child: const Icon(Icons.add, color: Colors.black, size: 30),
  // ),
    );
  }
}
