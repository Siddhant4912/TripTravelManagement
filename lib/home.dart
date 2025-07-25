import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/discover/users_tripsdetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/mytripdetails.dart';
import 'package:flutter_application_1/widgets/users/userCardContainer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/widgets/cards.dart';
import 'package:flutter_application_1/widgets/createTrip/categoryfetch.dart';
import 'widgets/category.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  
  List catdata = [];

    
    List all_trips = [];
  List my_trips = [];



  _fetch_all_trip() async {
      var fetch_my_trip_url = Uri.parse(
          conn+"/Fetch_All_Trips/fetch_all_trips.php");
      var res = await http.get(fetch_my_trip_url);
      setState(() {
        all_trips = json.decode(res.body);
      });
    }
  _fetchcat() async {
    var fetchdataurl =
    Uri.parse(conn+"/fetch_data.php");
    var res = await http.get(fetchdataurl);
    setState(() {
      catdata = json.decode(res.body);
    });
  }


  _categoryPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CategoryFetchdata()));
  }

  var username = "";
var user_id = "";
  _getusername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    // username = prefs.getString('username') ?? 'Guest';
    user_id = prefs.getString('user_id') ?? '';
  });
}

_sendUserID() async {
  try {
    var loginurl = Uri.parse(conn+"MyTrips/fetch_my_trips.php");
    var res = await http.post(loginurl, body: {"user_id": user_id});
    if (res.statusCode == 200) {
      setState(() {
        my_trips = json.decode(res.body);
      });
    } else {
      // Handle server error
      print("Failed to fetch trips: ${res.statusCode}");
    }
  } catch (e) {
    // Handle connection error
    print("Error occurred: $e");
  }
}



  @override
  void initState() {
    super.initState();
     _getusername().then((_) {
    if (user_id.isNotEmpty) {
      _sendUserID();
    }
  });
    _fetchcat();
     _fetch_all_trip();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        
        body: SingleChildScrollView(
          
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child:             Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: InputBorder.none,
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  suffixIcon: const Icon(Icons.filter_list_rounded, color: Colors.orange),
                ),
              ),
            ),

              ),

                  const SizedBox(height: 0),
                 SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: catdata.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CategoriesContainer(
                    cat_name: "${catdata[i]["cat_name"]}",
                    cat_img: "$conn/images/category/${catdata[i]['cat_img']}",
                  ),
                ),
              ),
            ),
               Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Trips",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color:Colors.white),
                    ),
                    GestureDetector(
        onTap: () {
          // Add your action here
         
          print("View All tapped");
        },
        child: Text(
          "View All",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
                  ],
                ),
              ),
              SizedBox(
                height: 240,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                     for (var i = 0; i < my_trips.length; i++)
                          GestureDetector(
                            onTap: () {
                              print("Clicked Trip ID: ${my_trips[i]["trip_id"]}"); // Debugging
                        
                              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTripdetails(
                  tripId: my_trips[i]["trip_id"].toString(),
                  trip_to_end: my_trips[i]["trip_to_end"].toString(), // ✅ Convert to String if needed
                  trip_start_date: my_trips[i]["trip_start_date"].toString(), // ✅ Convert to String if needed
                  trip_end_date: my_trips[i]["trip_end_date"].toString() // ✅ Convert to String if needed
                ),
              ),
                              );
                            },
                            child: CardContainer(
                              tripId: my_trips[i]["trip_id"].toString(),
                              card_name: "${my_trips[i]["trip_from"]} To ${my_trips[i]["trip_to_end"]}",
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    _categoryPage();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 108, 0),
                        borderRadius: BorderRadius.circular(17)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Create New Trip",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
           
              SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                child: Column(
    
                  children: [
                     Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                 child: Text("All Trips", style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold, color: Colors.white),textAlign: TextAlign.start,),
                              ),
                            ),
                          for(var i = 0; i <all_trips.length; i++)
                            
                                  GestureDetector(
                      
                                    onTap: () {
                                        print("Clicked Trip ID: ${all_trips[i]["trip_id"]}"); // Debugging
                          
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UsersTripsdetails(
                                        tripId: all_trips[i]["trip_id"].toString(),
                                        trip_to_end: all_trips[i]["trip_to_end"].toString(), // ✅ Convert to String if needed
                                        trip_start_date: all_trips[i]["trip_start_date"].toString(), // ✅ Convert to String if needed
                                        trip_end_date: all_trips[i]["trip_end_date"].toString() // ✅ Convert to String if needed
                                      ),
                                    ),
                                );
                                    },
                                    child: UserCardContainer(
                        user_name: "${all_trips[i]["username"]}",
                        trip_id : "${all_trips[i]["trip_id"]}",
                        card_name:"${all_trips[i]["trip_from"]} To ${all_trips[i]["trip_to_end"]}",
                         userImg: "${conn}/images/profile_image/${all_trips[i]["profile_image"]}",
                        card_img:"https://images.pexels.com/photos/14653174/pexels-photo-14653174.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      ),
                                  ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
