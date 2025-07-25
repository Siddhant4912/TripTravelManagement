import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAccommodationDetails extends StatefulWidget {
    final String? tripId;
  const UserAccommodationDetails({required this.tripId, Key? key})
      : super(key: key);

  @override
  State<UserAccommodationDetails> createState() => _UserAccommodationDetailsState();
}

class _UserAccommodationDetailsState extends State<UserAccommodationDetails> {
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
        padding: const EdgeInsets.only(bottom: 8.0),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A ),
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
                                    child: Text("Category",
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
                                      // _showBottomSheet(accommodation, accommodation_ID);
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
                                            // GestureDetector(
                                            //     onTap: () {
                                            //       showDialog(
                                            //         context: context,
                                            //         builder:
                                            //             (BuildContext context) {
                                            //           return AlertDialog(
                                            //             title: Text(
                                            //                 "Confirm Deletion"),
                                            //             content: Text(
                                            //                 "Are you sure you want to delete this item?"),
                                            //             actions: [
                                            //               TextButton(
                                            //                 onPressed: () {
                                            //                   Navigator.of(
                                            //                           context)
                                            //                       .pop();
                                            //                 },
                                            //                 child:
                                            //                     Text("Cancel"),
                                            //               ),
                                            //               TextButton(
                                            //                 onPressed: () {
                                            //                    var accommodation_ID = accommodation['accommodation_id'];

                                            //                     Navigator.of(context)
                                            //                         .pop();

                                            //                         print(accommodation_ID);
                                            //                 },
                                            //                 child: Text(
                                            //                     "Delete",
                                            //                     style: TextStyle(
                                            //                         color: Colors
                                            //                             .red)),
                                            //               ),
                                            //             ],
                                            //           );
                                            //         },
                                            //       );
                                            //     },
                                            //     child: Icon(
                                            //         Icons.delete_forever,
                                            //         color: Colors.red))
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


                  
  //                 // Add Floating Action Button
  // floatingActionButton: FloatingActionButton(
  //   backgroundColor: Colors.greenAccent,
  //   onPressed: () {
  //     // _showCreateExpenseDialog();
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //       builder: (context) => CreateExpensePage(tripId: widget.trip_id,)));
  //     print("hello accommodaiton");
     

  //   },
  //   child: const Icon(Icons.add, color: Colors.black, size: 30),
  // ),
    );
  }
}
