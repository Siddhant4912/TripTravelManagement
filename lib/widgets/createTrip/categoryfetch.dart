import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:flutter_application_1/splashscreen.dart';
import 'package:flutter_application_1/widgets/createTrip/categoryPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryFetchdata extends StatefulWidget {
  const CategoryFetchdata({super.key});

  @override
  State<CategoryFetchdata> createState() => _CategoryFetchdataState();
}



class _CategoryFetchdataState extends State<CategoryFetchdata> {

   int?  _selectedValue;
   var startDate ="";
   var _cat_img ="";

List catdata = [];

_fetchcat() async {
  var fetchdataurl = Uri.parse(conn+"/fetch_data.php");
  var res = await http.get(fetchdataurl);
  setState(() {
    catdata = json.decode(res.body);
  });
}

_cagtegoryNext() {

  if (_cat_img.isEmpty) {
    Fluttertoast.showToast(msg: "Please select a category first");
    return;
  }else{
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RegistrationForm(
        category: _selectedValue!,
        cat_img: _cat_img,
      ),
    ),
  );
}
}




@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchcat();
  }

   
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Category Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Iterating through categories and creating styled RadioListTiles
            for (var i = 0; i < catdata.length; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedValue = int.parse(catdata[i]["cat_id"]!);
                       _cat_img = catdata[i]["cat_img"]!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedValue == int.parse(catdata[i]["cat_id"]!)
                          ? Colors.blueAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _selectedValue == int.parse(catdata[i]["cat_id"]!)
                            ? Colors.blueAccent
                            : Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Display the image inside a circle
                      // Spacing between image and text

                        // Radio button for selection
                       Radio<int>(
  value: int.parse(catdata[i]["cat_id"]!),
  groupValue: _selectedValue,
  onChanged: (value) {
    setState(() {
      _selectedValue = value!;
      _cat_img = catdata[i]["cat_img"]!;
    });
  },
),

                        Expanded(
                          child: Text(
                            catdata[i]['cat_name']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                ),
              ),
            ],
            // Continue button with a modern gradient design
            GestureDetector(
              onTap: _cagtegoryNext,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RegistrationForm extends StatefulWidget {
  int category;

    final String cat_img;

RegistrationForm({Key? key, required this.category, required this.cat_img}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {

  String _selectedOption = 'private';
  final TextEditingController _trip_start_from = TextEditingController(); 
  final TextEditingController _trip_to_end= TextEditingController(); 
  final TextEditingController _trip_start_date = TextEditingController(); 
  final TextEditingController _trip_end_date = TextEditingController(); 
  
  // TextEditingController _selectedOption = TextEditingController();
  // DateTime selectedDate = DateTime.now();

 
var user_id = "";
_getusername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
      user_id = prefs.getString("user_id").toString();
    });
}
  

  

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   _getusername();
 }



  
_createNewTrip() async {
  // Validate required fields
  if (_trip_start_from.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please enter a start location",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  if (_trip_to_end.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please enter an end location",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  if (_trip_start_date.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please select a start date",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  if (_trip_end_date.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please select an end date",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  if (_selectedOption == null) {
    Fluttertoast.showToast(
      msg: "Please select a group security option",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  if (widget.cat_img.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please select a category image",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return; // Stop further execution if validation fails
  }

  // If all validations pass, proceed with the API call
  Navigator.push(context, MaterialPageRoute(builder: (context) => NavigatorPage()));

  var signupurl = Uri.parse(conn + "/CreateTrip/createtrip.php");
  print(widget.cat_img);

  var res = await http.post(signupurl, body: {
    "trip_start_from": _trip_start_from.text,
    "trip_to_end": _trip_to_end.text,
    "trip_start_date": _trip_start_date.text,
    "trip_end_date": _trip_end_date.text,
    "group_security": _selectedOption,
    "user_id": user_id.toString(),
    "category_id": widget.category.toString(),
    "trip_banner": widget.cat_img.toString()
  }).then((response) {
    print(response.body);
    var decodeddata = json.decode(response.body);
    print(decodeddata['status']);
    if (decodeddata['status'] == 'data inserted') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
  });

  print("hello");
  print(widget.category.toString());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text("Create Trip"),
      ),
      body:SingleChildScrollView(
      
        child: Column(
          children: [

              


                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _trip_start_from,
                        decoration: InputDecoration(
                    labelText: "Start From",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.near_me, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                   
                  ),
                                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _trip_to_end,
                        decoration: InputDecoration(
                    labelText: "To",
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.place_outlined, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                   
                  ),
                                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _trip_start_date,
                                              style: TextStyle(color: Colors.white),

                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Start Date",
                            labelStyle:TextStyle(color: Colors.white) ,
                            prefixIcon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                            
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 124, 121, 121),
                            )),

                            onTap: () async {
                              DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(2024), 
                    lastDate:DateTime(2027));

                    if (pickeddate!=null) {
                      setState(() {
                      _trip_start_date.text = ("${pickeddate.year}-${pickeddate.month}-${pickeddate.day}");
                      });
                      
                    }               
                   },
                      ),
                   
                  ),
                                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _trip_end_date,
                        style: TextStyle(color: Colors.white),
                        
                        decoration: const InputDecoration(
                            
                            border: OutlineInputBorder(),

                            labelText: "End Date",
                                   labelStyle:TextStyle(color: Colors.white) ,

                            prefixIcon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                            
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),

                            onTap: () async {
                              DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(2024), 
                    lastDate:DateTime(2027));

                    if (pickeddate!=null) {
                      setState(() {
                      _trip_end_date.text = ("${pickeddate.year}-${pickeddate.month}-${pickeddate.day}");
                     
                      });
                      
                    }               
                   },
                      ),
                   
                  ),
                                ),
                ),
                
              
                  
                Container(
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                         activeColor: Colors.blue,
                          value: 'private', groupValue:_selectedOption, onChanged: (value){
                            setState(() {
                            // controller: _groupSecurity;

                              _selectedOption = value!;
                            // _groupSecurity.text= "private";
                              print("value  + $_selectedOption");
                            });
                        }),
                        const Text("Private",style: TextStyle(color: Colors.white),),
                         Radio<String>(
                          activeColor: Colors.blue,
                    value: 'public',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                        print("Selected Option: $_selectedOption");
                      });
                    },
                  ),
                  const Text("Public",style: TextStyle(color: Colors.white),),
                      ],
                    ),

                    
                  ),

                   Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                 
                  onTap: (){
                    _createNewTrip();
                  },

                  child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 108, 0),
                          borderRadius: BorderRadius.circular(17)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              child: const Text(
                                "Create New Trip",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        
                        ],
                      )),
                ),
              ),



          




              

               
          ],
        ),
      )
      
    );
  }
}













