import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/tripDetails/accommodationDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/documentsDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/expensesDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/transportation_details.dart';
import 'package:flutter_application_1/widgets/tripDetails/tripPhotos.dart';
import 'package:flutter_application_1/widgets/users/userTripPhotos.dart';
import 'package:flutter_application_1/widgets/users/useraccommodation.dart';
import 'package:flutter_application_1/widgets/users/usersdocumentd.dart';
import 'package:flutter_application_1/widgets/users/usertransportationdetail.dart';
import 'package:flutter_application_1/widgets/users/usertripexpenses.dart';
import 'package:http/http.dart' as http;

class UsersTripsdetails extends StatefulWidget {
  var tripId;
  var trip_to_end; 
  var trip_start_date;
  var trip_end_date; // ✅ Store trip ID

  UsersTripsdetails({Key? key, this.tripId, this.trip_to_end, this.trip_start_date, this.trip_end_date}) : super(key: key); 


  @override
  State<UsersTripsdetails> createState() => _UsersTripsdetailsState();
}

class _UsersTripsdetailsState extends State<UsersTripsdetails> {


  bool isLoading = true;
  String? photoUrl;


  Future<void> _fetchMyprofilePhoto() async {
  setState(() {
    isLoading = true; // Start loading state
  });

  try {
    var fetchMyphotoUrl = Uri.parse(
        "$conn/edit_profile/fetch_trip_banner.php?trip_id=${widget.tripId}");
// print("tri _id"+ widget.tripId);f
    // print("🔄 Fetching photo from: $fetchMyphotoUrl"); // Debug: Log the URL being called.

    var res = await http.get(fetchMyphotoUrl);

    // print("🔄 Response status: ${res.statusCode}"); // Log status code
    // print("📜 Response body: ${res.body}"); // Log raw response body

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      // print("📜 Decoded JSON: $jsonData"); // Log decoded JSON

      // Check if photo_url exists in the response
      if (jsonData.containsKey("photo_url")) {
        setState(() {
          photoUrl = jsonData["photo_url"];
          isLoading = false; // Stop loading on success
        });
        // print("🖼️ Fetched Photo URL: $photoUrl"); // Log fetched photo URL
      } else {
        setState(() {
          isLoading = false; // Stop loading on missing photo_url
        });
        throw Exception("photo_url key is missing in the response.");
      }
    } else {
      setState(() {
        isLoading = false; // Stop loading if the response is not 200
      });
      throw Exception("Failed to load photo (Status: ${res.statusCode})");
    }
  } catch (e) {
    setState(() {
      isLoading = false; // Stop loading on error
    });
    // print("❌ Error fetching photo: $e"); // Log error message
  }
}

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final apiKey = '9a876521848b4e954d91f882436ab5f5'; // Replace with your actual API key
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // print("❌ Weather error: $e");
      throw Exception('Error fetching weather data');
    }
  }


   @override
  void initState() {
    super.initState();
      _fetchMyprofilePhoto();
      }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0c0d11),
          appBar: AppBar(
            toolbarHeight: 150,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false, //Removes default back button
            flexibleSpace: Container(
               decoration: BoxDecoration(
                  image: photoUrl != null && photoUrl!.isNotEmpty
                      ? DecorationImage(
              image: NetworkImage(photoUrl!),
              fit: BoxFit.cover,
                        )
                      : null, // No image if photoUrl is null or empty
                  color: Colors.grey, // Background color when there is no image
                ),
                child: photoUrl == null || photoUrl!.isEmpty
                    ? const Icon(Icons.person, size: 100, color: Colors.white) // Fallback icon when there's no photo
                    : null, 
             
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom:55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Center-Left Icon (Back)
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7), // Light color
                      radius: 20,
                      child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black), // Dark icon for contrast
                    ),
                  ),
              
                  // Center Icon (Photo)
              
                  // Center-Right Icon (Settings)
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7), // Light color
                    radius: 20,
                    child: const Icon(Icons.settings, size: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
          
             
            child: Padding(
            padding: const EdgeInsets.only(left: 0.8, top: 40,), // Adjust space for stacked container
              child: Column(
                children: [
               



    

    Padding(
      padding: const EdgeInsets.only(top: 12),
      
      child: Column(
        
        children: [


          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,left: 8.0, right: 8.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchWeather(widget.trip_to_end),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white70));
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Text("Weather data not available", style: TextStyle(color: Colors.white70));
                }
            
                final weatherData = snapshot.data!;
                final city = weatherData['name'];
                final temp = weatherData['main']['temp'].toString();
                final feelsLike = weatherData['main']['feels_like'].toString();
                final description = weatherData['weather'][0]['description'];
                final icon = weatherData['weather'][0]['icon'];
                final humidity = weatherData['main']['humidity'].toString();
                final wind = weatherData['wind']['speed'].toString();
            
                return SizedBox(
            
                    width: double.infinity,
              height: 200, // Set the height you prefer
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2f37), Color(0xFF0a1215)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(2, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: Color(0xFFffd700), size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "$city",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.location_pin, color: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Main weather info row
                  Row(
                    children: [
                      // Image.network(
                      //   'http://openweathermap.org/img/wn/$icon@2x.png',
                      //   height: 60,
                      //   width: 60,
                      // ),
                  
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$temp°C",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            description[0].toUpperCase() + description.substring(1),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(height: 5),
                  Divider(color: Colors.white12),
                  // const SizedBox(height: 5),
                  // Additional info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetail(Icons.water_drop, "Humidity", "$humidity%"),
                      _weatherDetail(Icons.air, "Wind", "$wind m/s"),
                      _weatherDetail(Icons.thermostat, "Feels Like", "$feelsLike°C"),
                    ],
                  ),
                ],
              ),
            ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserTripExpensesPage(
          tripId: widget.tripId
        )));
            },
            child: UserTripExpensesPage(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),

     GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserDocuementPage(
          tripId: widget.tripId
        )));
            },
            child: UserDocuementPage(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),
          
          GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserAccommodationDetails(
          tripId: widget.tripId
        )));
            },
            child: UserAccommodationDetails(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),

          GestureDetector(
            onTap: ( ){
                Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserTransportationDetails(
          tripId: widget.tripId
        )));
            },
            child: UserTransportationDetails(
                                      tripId: widget.tripId

            )
          ),


          GestureDetector(
            onTap: ( ){
              Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserTripphotos(
          tripId: widget.tripId
        )));
            },
            child: UserTripphotos(
                        tripId: widget.tripId

            ),
          ),

           
          
        ],
      ),
    )


        

                ],
              ),
            ),
            
                      

           
          

            
          ),
          
        ),

        

        // Positioned Container Between AppBar and Body
        // Positioned Container Between AppBar and Body
      Positioned(
  top: 150, // Positioned below the AppBar
  left: 30,
  right: 30,
  child: Container(
    height: 85, // Slightly increased height for better spacing
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5), // Improved padding
    decoration: BoxDecoration(
      color: const Color(0xFF0b1316),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          widget.trip_to_end,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
          
        ),
        const SizedBox(height: 6), // Added spacing between title and row

        // Date Row
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
            color: Color(0xFF0a1927),
            borderRadius: BorderRadius.all(Radius.circular(10)),

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               // Better spacing
              children: [
                Row(
                  
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.white70, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      widget.trip_start_date,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, decoration: TextDecoration.none),
                    ),
                                    const SizedBox(width: 10),
            
            
                       Icon(Icons.remove, color: Colors.white70, size: 16),   
                  ],
                ),
             
                Row(
                  children: [
                 
                    Padding(
                      padding: const EdgeInsets.only(left:0),
                      child: Text(
                        widget.trip_end_date,
                        style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(width: 5),
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

      ],
    );
  }
}


// Reusable helper widget:
Widget _weatherDetail(IconData icon, String label, String value) {
  return Column(
    children: [
      Icon(icon, color: Colors.white, size: 16),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      const SizedBox(height: 2),
      Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ],
  );
}