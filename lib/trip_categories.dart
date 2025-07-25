// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/connections/conn.dart';
// import 'package:flutter_application_1/widgets/discover/users_tripsdetails.dart';
// import 'package:flutter_application_1/widgets/users/userCardContainer.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;

// class CategoriesWiseTripData extends StatefulWidget {
//   const CategoriesWiseTripData({super.key});

//   @override
//   State<CategoriesWiseTripData> createState() => _CategoriesWiseTripDataState();
// }

// class _CategoriesWiseTripDataState extends State<CategoriesWiseTripData> {
//   List all_trips = [];
//   int? selectedCatId; // Nullable to handle uninitialized category ID
//   List catdata = [];

//   // Fetch categories from the backend
//   _fetchcat() async {
//     var fetchdataurl = Uri.parse("$conn/fetch_data.php");

//     try {
//       var res = await http.get(fetchdataurl);
//       if (res.statusCode == 200) {
//         var decoded = json.decode(res.body);
//         setState(() {
//           catdata = decoded;
//           if (catdata.isNotEmpty) {
//             selectedCatId = catdata[0]['category_id']; // Use first category's ID
//             _fetch_all_trip(selectedCatId!); // Fetch trips after setting category
//           } else {
//             Fluttertoast.showToast(msg: "No categories available");
//           }
//         });
//       } else {
//         Fluttertoast.showToast(msg: "Failed to fetch categories");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }

//   _fetch_all_trip(int catId) async {
//     var fetchTripsUrl = Uri.parse("$conn/Fetch_All_Trips/fetch_trip_categorywise.php?category_id=$catId");

//     try {
//       var res = await http.get(fetchTripsUrl);
//       if (res.statusCode == 200) {
//         var decodedTrips = json.decode(res.body);
//         setState(() {
//           all_trips = decodedTrips;
//         });
//       } else {
//         Fluttertoast.showToast(msg: "Failed to load trips");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchcat(); // Fetch categories initially
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 "All Trips",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),

//             // 🟡 Horizontal category list
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: catdata.length,
//                 itemBuilder: (context, index) {
//                   final cat = catdata[index];
//                   final catId = cat['category_id'];

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedCatId = catId;
//                       });
//                       _fetch_all_trip(selectedCatId!); // Fetch trips for selected category
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: selectedCatId == catId ? Colors.blue : Colors.grey[800],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                         child: Text(
//                           cat['category_name'],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 10),

//             // 🟢 Trip list
//             Expanded(
//               child: all_trips.isEmpty
//                   ? const Center(child: Text("No trips found", style: TextStyle(color: Colors.white)))
//                   : ListView.builder(
//                       itemCount: all_trips.length,
//                       itemBuilder: (context, i) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => UsersTripsdetails(
//                                   tripId: all_trips[i]["trip_id"].toString(),
//                                   trip_to_end: all_trips[i]["trip_to_end"].toString(),
//                                   trip_start_date: all_trips[i]["trip_start_date"].toString(),
//                                   trip_end_date: all_trips[i]["trip_end_date"].toString(),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: UserCardContainer(
//                             user_name: all_trips[i]["username"],
//                             trip_id: all_trips[i]["trip_id"],
//                             card_name: "${all_trips[i]["trip_from"]} To ${all_trips[i]["trip_to_end"]}",
//                             userImg: "$conn/images/profile_image/${all_trips[i]["profile_image"]}",
//                             card_img: "https://images.pexels.com/photos/14653174/pexels-photo-14653174.jpeg",
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/discover/users_tripsdetails.dart';
import 'package:flutter_application_1/widgets/users/userCardContainer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoriesWiseTripData extends StatefulWidget {
  const CategoriesWiseTripData({super.key});

  @override
  State<CategoriesWiseTripData> createState() => _CategoriesWiseTripDataState();
}

class _CategoriesWiseTripDataState extends State<CategoriesWiseTripData> {
  List all_trips = [];
  int? selectedCatId; // Nullable to handle uninitialized category ID
  List catdata = [];

  // Fetch categories from the backend
  _fetchcat() async {
    var fetchdataurl = Uri.parse("$conn/fetch_data.php");

    try {
      var res = await http.get(fetchdataurl);
      if (res.statusCode == 200) {
        var decoded = json.decode(res.body);
        setState(() {
          catdata = decoded;
          if (catdata.isNotEmpty) {
            selectedCatId = catdata[0]['category_id']; // Use first category's ID
            _fetch_all_trip(selectedCatId!); // Fetch trips after setting category
          } else {
            Fluttertoast.showToast(msg: "No categories available");
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch categories");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  _fetch_all_trip(int catId) async {
    var fetchTripsUrl = Uri.parse("$conn/Fetch_All_Trips/fetch_trip_categorywise.php?category_id=$catId");

    try {
      var res = await http.get(fetchTripsUrl);
      if (res.statusCode == 200) {
        var decodedTrips = json.decode(res.body);
        setState(() {
          all_trips = decodedTrips;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load trips");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchcat(); // Fetch categories initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
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
                    );
  }
}