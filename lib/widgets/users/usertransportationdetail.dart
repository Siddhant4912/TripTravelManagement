
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTransportationDetails extends StatefulWidget {
    final String? tripId;
  const UserTransportationDetails({Key? key, this.tripId}) : super(key: key);

  @override
  State<UserTransportationDetails> createState() => _UserTransportationDetailsState();
}

class _UserTransportationDetailsState extends State<UserTransportationDetails> {
 
_userTranportationDetailPage(){
   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserTransportation_details_page(
                  trip_id: widget.tripId.toString(),
                
                

                  // selectedExpenseId: '',
                )));
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _userTranportationDetailPage();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
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
                      color: Color(0xff0a1215 ),
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
                               const Text("Transportation",
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
                            ],
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



class UserTransportation_details_page extends StatefulWidget {
  final String trip_id;


  UserTransportation_details_page({Key? key, required this.trip_id,}) : super(key: key);

  @override
  State<UserTransportation_details_page> createState() =>
      UserTransportation_details_pageState();
}

class UserTransportation_details_pageState extends State<UserTransportation_details_page> {
  List<Map<String, dynamic>> transportation_list = [];
  bool isLoading = true;
  String errorMessage = "";
  String? _selectedDate;
  String selectedTransportationId = "";

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _startfromController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();




  @override
  void initState() {
    super.initState();
    fetchTransportation_list();
  }
  
  
  Future<void> fetchTransportation_list() async {
  final String url = "$conn/MyTrips/fetch_tranportation_details.php?trip_id=${widget.trip_id}";
  print("Fetching from URL: $url");
  print(widget.trip_id);

  try {
    final response = await http.get(Uri.parse(url));
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

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
        // Since the response is a list of maps, directly decode it as such
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          transportation_list = data.map((item) {
            return {
              "transportation_id": item["transportation_id"] ?? "unknown",
              "category": item["category"] ?? "Unknown",
              "from": item["start_from"] ?? "Unknown",
              "destination": item["destination"] ?? "Unknown",
              "travel_date": item["travel_date"] ?? "N/A",
            };
          }).toList();
          isLoading = false;
          errorMessage = transportation_list.isEmpty ? "No Data Available" : "";
        });
      } catch (e) {
        print("JSON parsing error: $e");
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
    print("Network error: $error");
    setState(() {
      errorMessage = "Error fetching data: $error";
      isLoading = false;
    });
  }
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
      body:Padding(
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
        // Handle onTap if needed
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(transportation['category'], style: const TextStyle(color: Colors.white))),
            Expanded(child: Text(transportation['from'], style: const TextStyle(color: Colors.white))),
            Expanded(child: Text(transportation['destination'], style: const TextStyle(color: Colors.white))),
            Expanded(child: Text(transportation['travel_date'], style: const TextStyle(color: Colors.white))),
          ],
        ),
      ),
    ),
  );
}

                        ),
                      ),
                    ],
                  ),
                ),
      

      
    );
  }
}

