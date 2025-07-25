import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpensesContainer extends StatefulWidget {
  const ExpensesContainer({super.key});

  @override
  State<ExpensesContainer> createState() => _ExpensesContainerState();
}

class _ExpensesContainerState extends State<ExpensesContainer> {
  _expenses() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateExpensePage()));

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _expenses();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 0,
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
                      color: Color(0xff1c1c1e),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF1a2a29),
                                child: Icon(Icons.attach_money_rounded,
                                    color: Color(0xFF01a686)),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Expenses",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          Padding(
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
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Color(0xFF1a2a29),
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF01a686),
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CreateExpensePage(),
    );
  }
}

class CreateExpensePage extends StatefulWidget {
  const CreateExpensePage({Key? key}) : super(key: key);

  @override
  _CreateExpensePageState createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final TextEditingController _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Expense"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(
                        "assets/expense_banner.jpg"), // Replace with your image asset
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
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text("1", style: TextStyle(color: Colors.white)),
                      ),
                      Container(height: 60, width: 2, color: Colors.grey),
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: const Text("2",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Container(height: 60, width: 2, color: Colors.grey),
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: const Text("3",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Step Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What was paid?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // TextField with Button
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
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
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Step 2 & 3
                        const Text(
                          "How much was paid?",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
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
                            ),
                          ],
                        ),

                        const Text(
                          "When was it paid? (optional)",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
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
}
