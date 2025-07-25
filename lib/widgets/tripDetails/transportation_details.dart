
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransportationDetails extends StatefulWidget {
    final String? tripId;
  const TransportationDetails({Key? key, this.tripId}) : super(key: key);

  @override
  State<TransportationDetails> createState() => _TransportationDetailsState();
}

class _TransportationDetailsState extends State<TransportationDetails> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedDate;
  String selectedCategory = "Bus"; // Default category



  var user_id = "";
  _getusername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString("user_id") ?? "";
    });
  }

    @override
  void initState() {
    super.initState();
    _getusername();
  }
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

Future<void> _submitData() async {
   if (widget.tripId == null) {
      Fluttertoast.showToast(
        msg: "Error: Trip ID is missing",
        backgroundColor: Colors.red,
      );
      return;
    }

    print(widget.tripId);
    var signupurl = Uri.parse(conn + "/MyTrips/create_transportation.php");

    var res = await http.post(signupurl, body: {
      "trip_id": widget.tripId.toString(),
    "user_id": user_id,
    "start_from": _startController.text.trim(),
    "destination": _destinationController.text.trim(),
    "travel_date": _selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    "transport_category": selectedCategory,
    });

    print(res.body);
    var decodeddata = json.decode(res.body);
    print(decodeddata['status']);

    if (decodeddata['status'] == 'data inserted') {
      Fluttertoast.showToast(
        msg: "Expense added successfully!",
        backgroundColor: Colors.green,
      );
       setState(() {
        _startController.clear();
        _destinationController.clear();
        _selectedDate = null;
        
      });

      Navigator.pop(context); // Go back to the previous screen
    } else {
      Fluttertoast.showToast(
        msg: decodeddata['status'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
}



  void _showAddTransportationModal() {
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
                const Text(
                  "Add Transportation",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                _buildTextField(_startController, "From"),
                const SizedBox(height: 8),
                _buildTextField(_destinationController, "Destination"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDate,
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
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _submitData();
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
Widget _buildCategoryDropdown() {
  // Define icons for each transport category
  Map<String, IconData> categoryIcons = {
    "Bus": Icons.directions_bus,
    "Car": Icons.directions_car,
    "Train": Icons.directions_railway,
    "Flight": Icons.flight,
    "Ship": Icons.directions_boat,
    "Other": Icons.more_horiz,
  };

  return DropdownButtonFormField<String>(
    value: selectedCategory,
    dropdownColor: Colors.black, // Keep dropdown dark-themed
    decoration: InputDecoration(
      labelText: "Transport Category",
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    style: const TextStyle(color: Colors.white),
    items: categoryIcons.keys.map((category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Row(
          children: [
            Icon(categoryIcons[category], color: Colors.green), // Icon
            const SizedBox(width: 10), // Space between icon and text
            Text(category, style: const TextStyle(color: Colors.white)),
          ],
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        selectedCategory = value!;
      });
    },
  );
}

_Transportation_detail_page(){
   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Transportation_details_page(
                  trip_id: widget.tripId.toString(),
                  userId: user_id,

                  // selectedExpenseId: '',
                )));
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                _Transportation_detail_page();

      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0,left: 8.0, right: 8.0),
        child: Card(
        
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xff0a1215),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.airplanemode_active,
                                  color: Color(0xFF01a686)),
                              const SizedBox(width: 10),
                              const Text(
                                "Transportation",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),

                              const Padding(
                        padding: EdgeInsets.only(left: 0.8, top: 15,bottom: 15, right: 15),
                        child: CircleAvatar(
                          
                          backgroundColor: Color(0xFF1a2a29),
                          child: Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF01a686), size: 10,),
                        ),
                      ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _showAddTransportationModal,
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



class Transportation_details_page extends StatefulWidget {
  final String trip_id;
  final String userId;

  Transportation_details_page({Key? key, required this.trip_id, required this.userId}) : super(key: key);

  @override
  State<Transportation_details_page> createState() =>
      _Transportation_details_pageState();
}

class _Transportation_details_pageState extends State<Transportation_details_page> {
  List<Map<String, dynamic>> transportation_list = [];
  bool isLoading = true;
  String errorMessage = "";
  String? _selectedDate;
  String selectedTransportationId = "";
String selectedCategory = "Bus";
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _startfromController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();


  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
Widget _buildCategoryDropdown() {
  // Define icons for each transport category
  Map<String, IconData> categoryIcons = {
    "Bus": Icons.directions_bus,
    "Car": Icons.directions_car,
    "Train": Icons.directions_railway,
    "Flight": Icons.flight,
    "Ship": Icons.directions_boat,
    "Other": Icons.more_horiz,
  };

  return DropdownButtonFormField<String>(
    value: selectedCategory,
    dropdownColor: Colors.black, // Keep dropdown dark-themed
    decoration: InputDecoration(
      labelText: "Transport Category",
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    style: const TextStyle(color: Colors.white),
    items: categoryIcons.keys.map((category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Row(
          children: [
            Icon(categoryIcons[category], color: Colors.green), // Icon
            const SizedBox(width: 10), // Space between icon and text
            Text(category, style: const TextStyle(color: Colors.white)),
          ],
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        selectedCategory = value!;
      });
    },
  );
}


   Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
     
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTransportation_list();
  }

  Future<void> fetchTransportation_list() async {
    final String url = "$conn/MyTrips/fetch_tranportation_details.php?trip_id=${widget.trip_id}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.body.trim().isEmpty) {
        setState(() {
          transportation_list = [];
          isLoading = false;
          errorMessage = "No Data Available";
        });
        return;
      }

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            transportation_list = data.map((item) => {
              "transportation_id": item["transportation_id"] ?? "unknown",
              "category": item["category"] ?? "Unknown",
              "from": item["start_from"] ?? "Unknown",
              "destination": item["destination"] ?? "Unknown",
              "travel_date": item["travel_date"] ?? "N/A",
            }).toList();
            isLoading = false;
            errorMessage = transportation_list.isEmpty ? "No Data Available" : "";
          });
        } catch (e) {
          setState(() {
            errorMessage = "Invalid data format";
            isLoading = false;
          });
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
  _update_transportation(transportation_ID) async {
  var updateUrl = Uri.parse("$conn/MyTrips/update_transportation.php");

  print("Updating transportation ID: $transportation_ID");
  print("Selected Category: $selectedCategory");
  print("Start From: ${_startfromController.text}");
  print("Destination: ${_destinationController.text}");
  print("Travel Date: $_selectedDate");

  var res = await http.post(
    updateUrl,
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      "transportation_id": transportation_ID,
      "transportation_category": selectedCategory,
      "start_from": _startfromController.text,
      "destination": _destinationController.text,
      "travel_date": _selectedDate ?? '',
    },
  );

  print("Response Body: ${res.body}");

  var decodedData = json.decode(res.body);
  if (decodedData['status'] == 'Transportation updated successfully') {
    Fluttertoast.showToast(
      msg: "Transportation updated successfully",
      backgroundColor: Colors.green,
    );
    fetchTransportation_list();
  } else {
    Fluttertoast.showToast(
      msg: decodedData['status'],
      backgroundColor: Colors.red,
    );
  }
}



delete_transportation(String transportation_ID) async {
  final deleteUrl = Uri.parse("$conn/MyTrips/delete_travel_details.php");
  print("➡️ Delete URL: $deleteUrl");
  print("➡️ Deleting transportation_ID: $transportation_ID");

  try {
    var res = await http.post(
      deleteUrl,
      body: {
        "transportation_id": transportation_ID,
      },
    );

    print("🟢 Server Response Code: ${res.statusCode}");
    print("🟢 Server Response Body: ${res.body}");

    try {
      var decodedData = json.decode(res.body);
      print("🟢 Decoded Response: $decodedData");

      if (decodedData.containsKey("success")) {
        Fluttertoast.showToast(
          msg: decodedData["success"],
          backgroundColor: Colors.green,
        );
        fetchTransportation_list(); // Refresh list
      } else {
        Fluttertoast.showToast(
          msg: decodedData['error'] ?? "❌ Failed to delete Transportation",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("❌ JSON Decode Error: $e");
      Fluttertoast.showToast(
        msg: "❌ Error parsing server response.",
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    print("❌ HTTP Error: $e");
    Fluttertoast.showToast(
      msg: "⚠️ Network error! Please try again.",
      backgroundColor: Colors.red,
    );
  }
}


  
void _showBottomSheet(Map<String, dynamic> transportation, transportationId) {
  _categoryController.text = transportation["category"] ?? '';
  _startfromController.text = transportation["from"] ?? '';
  _destinationController.text = transportation["destination"] ?? '';
  _selectedDate = transportation["travel_date"] ?? '';

  selectedTransportationId = transportation["transportation_id"];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView( // Important for isScrollControlled
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                      _buildCategoryDropdown(),
                const SizedBox(height: 16),
               TextField(
                  controller: _startfromController,
                  decoration: InputDecoration(
                    labelText: "From",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 16),
               TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: "Destination",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => _pickDate(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate ?? "Select a travel date",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                           var transportation_ID = transportation['transportation_id'];
                    _update_transportation(transportation_ID);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
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
        title: const Text("Transportation Details", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : FutureBuilder(
                          future: fetchTransportation_list(),
                  builder: (context, snapshot) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey[900],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(child: Text("Category", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Expanded(child: Text("From", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Expanded(child: Text("Destination", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Expanded(child: Text("Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: transportation_list.length,
                            itemBuilder: (context, index) {
                              final transportation = transportation_list[index];
                              return Card(
                                color: Colors.grey[850],
                                child: GestureDetector(
                                  onTap: () {
                                    var transportation_ID = transportation['transportation_id'];
                                    _showBottomSheet(transportation, transportation_ID);
                                  },
                                  child: Container(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(transportation["category"], style: const TextStyle(color: Colors.white))),
                                          Expanded(child: Text(transportation["from"], style: const TextStyle(color: Colors.white))),
                                          Expanded(child: Text(transportation["destination"], style: const TextStyle(color: Colors.white))),
                                          Expanded(child: Row(
                                            children: [
                                              Text(transportation["travel_date"], style: const TextStyle(color: Colors.white)),

                                                
                                            ],
                                          )),
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
                                                            "Are you sure you want to delete this ?"),
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
                                                               var transportation_ID = transportation['transportation_id'];
                                                                     Navigator.of(context)
                                                                    .pop();
                                                                 delete_transportation(transportation_ID);
                                                           

                                                                   
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
                  }
              ),
      

      
    );
  }
}

