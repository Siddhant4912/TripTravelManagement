

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

class ExpensesContainer extends StatefulWidget {
  final String? tripId;
  const ExpensesContainer({Key? key, required this.tripId}) : super(key: key);

  @override
  State<ExpensesContainer> createState() => _ExpensesContainerState();
}

class _ExpensesContainerState extends State<ExpensesContainer> {
  _add_expenses() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateExpensePage(tripId: widget.tripId)));

    print(widget.tripId);
  }

  _expenses_detail_page() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExpesnsesDetailsPage(
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
        padding: const EdgeInsets.only(bottom: 8.0,left: 8.0, right: 8.0),
        child: Card(
          elevation: 0,
           color: Color(0xFF1A1A1A),
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
                          GestureDetector(
                            onTap: () => _add_expenses(),
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

class CreateExpensePage extends StatefulWidget {
  final String? tripId;
  const CreateExpensePage({Key? key, this.tripId}) : super(key: key);

  @override
  _CreateExpensePageState createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedDate;
  bool _isStep1Completed = false;
  bool _isStep2Completed = false;
  bool _isStep3Completed = false;

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
    _subjectController.addListener(_checkStep1);
    _amountController.addListener(_checkStep2);
  }

  void _checkStep1() {
    setState(() {
      _isStep1Completed = _subjectController.text.isNotEmpty;
    });
  }

  void _checkStep2() {
    setState(() {
      _isStep2Completed = _amountController.text.isNotEmpty;
    });
  }

  // Function to pick date
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
        _isStep3Completed = true;
      });
    }
  }

  _createNewExpenses() async {
    if (widget.tripId == null) {
      Fluttertoast.showToast(
        msg: "Error: Trip ID is missing",
        backgroundColor: Colors.red,
      );
      return;
    }

    print(widget.tripId);
    var signupurl = Uri.parse(conn + "/MyTrips/create_trip_expenses.php");

    var res = await http.post(signupurl, body: {
      "trip_id": widget.tripId.toString(),
      "paid_category": _subjectController.text,
      "how_much_paid": _amountController.text,
      "when_was_it_paid": _selectedDate,
      "user_id": user_id.toString(),
    });

    print(res.body);
    var decodeddata = json.decode(res.body);
    print(decodeddata['status']);

    if (decodeddata['status'] == 'data inserted') {
      Fluttertoast.showToast(
        msg: "Expense added successfully!",
        backgroundColor: Colors.green,
      );

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

  @override
  Widget build(BuildContext context) {
    bool isAllStepsCompleted =
        _isStep1Completed && _isStep2Completed && _isStep3Completed;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.tripId.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://img.freepik.com/free-vector/finance-department-employees-are-calculating-expenses-company-s-business_1150-41782.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Stepper Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      // Step 1
                      CircleAvatar(
                        backgroundColor:
                            _isStep1Completed ? Colors.green : Colors.grey[800],
                        child: const Text("1",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Container(
                        height: 55,
                        width: 2,
                        color:
                            _isStep1Completed ? Colors.green : Colors.grey[800],
                      ),

                      // Step 2
                      CircleAvatar(
                        backgroundColor:
                            _isStep2Completed ? Colors.green : Colors.grey[800],
                        child: const Text("2",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Container(
                        height: 60,
                        width: 2,
                        color:
                            _isStep2Completed ? Colors.green : Colors.grey[800],
                      ),

                      // Step 3
                      CircleAvatar(
                        backgroundColor:
                            _isStep3Completed ? Colors.green : Colors.grey[800],
                        child: const Text("3",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Step Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step 1
                        const Text("What was paid?",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 10),

                        // TextField for Step 1
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _subjectController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            hintText: "Enter subject ...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Step 2
                        const Text("How much was paid?",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 10),

                        // Amount TextField
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            hintText: "Enter amount ...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Step 3 - Date Selection
                        const Text("When was it paid?",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 10),

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
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Icon(Icons.calendar_today,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Save Button (Only appears when all steps are completed)
                        if (isAllStepsCompleted)
                          ElevatedButton(
                            onPressed: () {
                              _createNewExpenses();
                              // Implement save functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

class ExpesnsesDetailsPage extends StatefulWidget {
  final String trip_id; // Ensure trip_id is a string
  final String selectedExpenseId;

  ExpesnsesDetailsPage(
      {Key? key, required this.trip_id, required this.selectedExpenseId})
      : super(key: key);

  @override
  State<ExpesnsesDetailsPage> createState() => _ExpesnsesDetailsPageState();
}

class _ExpesnsesDetailsPageState extends State<ExpesnsesDetailsPage> {
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

  _update_expenses(expense_id) async {
    var updateUrl = Uri.parse(conn + "/MyTrips/update_trip_expenses.php");

    var res = await http.post(
      updateUrl,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "expenses_id": expense_id,
        "paid_category": _categoryController.text,
        "how_much_paid": _amountController.text,
        "when_was_it_paid": _selectedDate,
      },
    );
    var decodedData = json.decode(res.body);

    if (decodedData['status'] == 'Expense updated successfully') {
      Fluttertoast.showToast(
        msg: "Expense updated successfully!",
        backgroundColor: Colors.green,
      );

      fetchExpenses();
    } else {
      Fluttertoast.showToast(
        msg: decodedData['status'],
        backgroundColor: Colors.red,
      );
    }
  }

  _delete_trip_expense(expense_id) async {
    var deleteUrl = Uri.parse(
        conn + "/MyTrips/delete_trip_expenses.php" //  Correct endpoint
        );

    try {
      var res = await http.post(
        deleteUrl,
        // headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "expenses_id": expense_id.toString(),
        },
      );

      var decodedData = json.decode(res.body);

      if (decodedData.containsKey("success")) {
        //  Correct success check

        Fluttertoast.showToast(
          msg: "Expense Deleted successfully!",
          backgroundColor: Colors.green,
        );

        fetchExpenses(); // R
      } else {
        Fluttertoast.showToast(
          msg: decodedData['error'] ?? "Failed to delete expense",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("⚠️ Error deleting expense: $e");
      Fluttertoast.showToast(
        msg: "⚠️ Network error! Please try again.",
        backgroundColor: Colors.red,
      );
    }
  }

  void _showBottomSheet(Map<String, dynamic> expense, expense_id) {
    // Set the selected expense details in text fields
    print("id fpound" + expense_id);
    _categoryController.text = expense["paid_category"];
    _amountController.text = expense["how_much_paid"];
    _selectedDate = expense["when_was_it_paid"];
    selectedExpenseId = expense["expenses_id"];

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
                    labelText: "Category",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.category, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Amount Input
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon:
                        const Icon(Icons.attach_money, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Date Input
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
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Update expense logic here
                    _update_expenses(expense_id);
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
                                    "${getTotalSpent().toStringAsFixed(2)}",
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
                                      _showBottomSheet(expense, expense_id);
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
                                                              var expense_id =
                                                                  expense[
                                                                      'expenses_id'];
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _delete_trip_expense(
                                                                  expense_id);
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
  floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.greenAccent,
    onPressed: () {
      // _showCreateExpenseDialog();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateExpensePage(tripId: widget.trip_id,)));

    },
    child: const Icon(Icons.add, color: Colors.black, size: 30),
  ),
    );
  }
}
