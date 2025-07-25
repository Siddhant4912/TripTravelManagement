  import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/category.dart';
import 'package:flutter_application_1/widgets/categorypages/popular_category.dart';
import 'package:flutter_application_1/widgets/discover/users_tripsdetails.dart';
import 'package:flutter_application_1/widgets/explore/popularcategories.dart';
  import 'package:flutter_application_1/widgets/users/userCardContainer.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';


  class Userhomepage extends StatefulWidget {
    const Userhomepage({super.key});

    @override
    State<Userhomepage> createState() => _UserhomepageState();
  }

  class _UserhomepageState extends State<Userhomepage> {
      
  List catdata = [];
    List all_trips = [];
    


      _fetchcat() async {
    var fetchdataurl =
        Uri.parse(conn+"fetch_data.php");
    var res = await http.get(fetchdataurl);
    setState(() {
      catdata = json.decode(res.body);
    });
  }





  _fetch_all_trip() async {
      var fetch_my_trip_url = Uri.parse(
          conn+"/Fetch_All_Trips/fetch_all_trips.php");
      var res = await http.get(fetch_my_trip_url);
      setState(() {
        all_trips = json.decode(res.body);
      });
    }


  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _fetch_all_trip();
      _fetchcat();
    }




    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.black,
           
body:SingleChildScrollView(
              
            child: Column(
              children: [
        
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      child: Column(
                               
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                               child: Text("Popular Categories", style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold, color: Colors.white),textAlign: TextAlign.start,),
                            ),
                          ),
                            
                          SizedBox(
                                          height:215,
                                          width: double.infinity,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                          for (var i = 0; i < catdata.length; i++)
                            PopularCategoriesContainer(
                              cat_name: "${catdata[i]["cat_name"]}",
                             cat_img:
                            "$conn/images/category/${catdata[i]['cat_img']}",
                                  cat_id:"${catdata[i]["cat_id"]}",
                            ),
                                            ],
                                          ),
                                        ),
                        ],
                      ),
                    ),
                  ),
                Container(
               
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  ),
                ),
        
                
                
              ],
            ),
        
        
        
           
        ),
          // **Floating Action Button for Search**
    

      );


    }
  }