import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/widgets/tripDetails/mytripdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserTripExpensesPage extends StatefulWidget {
  final String? tripId;
  const UserTripExpensesPage({Key? key, required this.tripId}) : super(key: key);

  @override
  State<UserTripExpensesPage> createState() => _UserTripExpensesPageState();
}

class _UserTripExpensesPageState extends State<UserTripExpensesPage> {
  
  _expenses_detail_page() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => userExpensesDetailPage(
                  trip_id: widget.tripId.toString(),
                  selectedExpenseId: '',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _expenses_detail_page();
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
                  // First Row: Expenses
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xff0a1215),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.attach_money_rounded,
                                  color: Color(0xFF0193ba)),
                              SizedBox(width: 10),
                              Text(
                                "Expenses",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
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
                          // GestureDetector(
                          //   onTap: () => _add_expenses(),
                          //   child: const CircleAvatar(
                          //     backgroundColor: Color(0xFF1a2a29),
                          //     child: Icon(Icons.add, color: Color(0xFF01a686)),
                          //   ),
                          // ),
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


class userExpensesDetailPage extends StatefulWidget {
  final String trip_id; // Ensure trip_id is a string
  final String selectedExpenseId;

  userExpensesDetailPage(
      {Key? key, required this.trip_id, required this.selectedExpenseId})
      : super(key: key);

  @override
  State<userExpensesDetailPage> createState() => _userExpensesDetailPageState();
}

class _userExpensesDetailPageState extends State<userExpensesDetailPage> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;
  String errorMessage = "";
  String? _selectedDate;
  String selectedExpenseId = "";

  // Controllers to show selected expense details
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();

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
    fetchExpenses();
    getTotalSpent();
  }

// Calculate total spent amount
  double getTotalSpent() {
    return expenses.fold(0, (sum, item) {
      double amount =
          double.tryParse(item["how_much_paid"].replaceAll("₹", "").trim()) ??
              0.0;
      return sum + amount;
    });
  }

  Future<void> fetchExpenses() async {
    final String url =
        conn + "/MyTrips/fetch_my_trip_expenses.php?trip_id=${widget.trip_id}";
    // 🔹 Debugging prints
    // print(" Sending update request...");
    // print(" Expense ID: ${widget.selectedExpenseId}");
    // print(" Category: ${_categoryController.text}");
    // print(" Amount: ${_amountController.text}");
    // print(" Date: $_selectedDate");
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          expenses = data
              .map((item) => {
                    "expenses_id": item["expenses_id"] ?? "unknown",
                    "paid_category": item["paid_category"] ?? "Unknown",
                    "how_much_paid": "${item["how_much_paid"] ?? "0"}",
                    "when_was_it_paid": item["when_was_it_paid"] ?? "N/A",
                  })
              .toList();

          if (expenses.isNotEmpty) {
            selectedExpenseId =
                expenses[0]["expenses_id"]; // Store first expense ID
            // print("Expenses ID ${selectedExpenseId}");
          }
          isLoading = false;
        });
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
      backgroundColor: Colors.black,
      appBar: AppBar(
                foregroundColor: Colors.white,

        backgroundColor: Colors.black,
        title: const Text("Expenses Details",
            style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : FutureBuilder(
                  future: fetchExpenses(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 50,
                              color: Colors.grey[850],
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // Keeps content compact
                                children: [
                                  // Money icon
                                  // Adds some spacing between the icon and text
                                  Text(
                                    "₹ ${getTotalSpent().toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 40),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                    child: Text("Amount",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text("Date",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          // Expandable List
                          Expanded(
                            child: ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return Card(
                                  color: Colors.grey[850],
                                  child: GestureDetector(
                                    onTap: () {
                                      var expense_id = expense['expenses_id'];
                                      print(expense_id);
                                      // _showBottomSheet(expense, expense_id);
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
                                                    expense["paid_category"],
                                                    style: const TextStyle(
                                                        color: Colors.white))),
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 20,
                                                  color: Colors.greenAccent,
                                                ),
                                                Text(expense["how_much_paid"],
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .greenAccent)),
                                              ],
                                            )),
                                            Expanded(
                                                child: Text(
                                                    expense["when_was_it_paid"],
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
                                            //                   var expense_id =
                                            //                       expense[
                                            //                           'expenses_id'];
                                            //                   Navigator.of(
                                            //                           context)
                                            //                       .pop();
                                            //                   // _delete_trip_expense(
                                            //                   //     expense_id);
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


                  // Add Floating Action Button
  // floatingActionButton: FloatingActionButton(
  //   backgroundColor: Colors.greenAccent,
  //   onPressed: () {
  //     // _showCreateExpenseDialog();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => CreateExpensePage(tripId: widget.trip_id,)));

  //   },
  //   child: const Icon(Icons.add, color: Colors.black, size: 30),
  // ),
    );
  }
}
