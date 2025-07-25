import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:flutter_application_1/widgets/category.dart';
import 'package:flutter_application_1/widgets/tripDetails/accommodationDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/documentsDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/expensesDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/transportation_details.dart';
import 'package:flutter_application_1/widgets/tripDetails/tripPhotos.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Define your colors
const Color backgroundColor = Color(0xFF121212); // Dark background
const Color textColor = Color(0xFFE0E0E0); // Light gray text
const Color accentTeal = Color(0xFF00BFA5); // Teal accent
const Color deleteRed = Color(0xFFF44336); // Delete button red
const Color cancelGray = Color(0xFFBDBDBD); // Cancel button gray



class MyTripdetails extends StatefulWidget {
   var tripId;
  var trip_to_end; 
  var trip_start_date;
  var trip_end_date; // ✅ Store trip ID

  MyTripdetails({Key? key, this.tripId, this.trip_to_end, this.trip_start_date, this.trip_end_date}) : super(key: key); 

  @override
  State<MyTripdetails> createState() => _MyTripdetailsState();
}

class _MyTripdetailsState extends State<MyTripdetails> {
  late Future<String?> _photoFuture;

  bool isLoading = true;
  String? photoUrl;
    String user_id = "";
 Map<String, dynamic>? weatherData;
bool isWeatherLoading = true;
  String weatherError = "";
    
  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString("user_id") ?? "";

    if (storedUserId.isNotEmpty) {
      setState(() {
        user_id = storedUserId;
            // _photoFuture =  _fetchMyprofilePhoto()

      });
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);

      // Navigate to the ViewImageBeforeUpload screen and pass the image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewTripBannerImagePage(
            imageFile: selectedImage,
            trip_id:widget.tripId,
          ),
        ),
      );
    }
  }


    Future<void> getWeather() async {
    try {
      final data = await fetchWeather(widget.trip_to_end);
      setState(() {
        weatherData = data;
        isWeatherLoading = false;
      });
    } catch (e) {
      setState(() {
        weatherError = "Weather data not available";
        isWeatherLoading = false;
      });
    }
  }
// Fetch weather data
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final String apiKey = "9a876521848b4e954d91f882436ab5f5"; // Replace with your actual API key
    final String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }


    _delete_trip(trip_id) async {
    var deleteUrl = Uri.parse(
        conn + "/MyTrips/delete_trip.php" //  Correct endpoint
        );

    try {
      var res = await http.post(
        deleteUrl,
        // headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "trip_id": trip_id.toString(),
        },
      );

      var decodedData = json.decode(res.body);

      if (decodedData.containsKey("success")) {
        //  Correct success check

        Fluttertoast.showToast(
          msg: "Trip Deleted successfully!",
          backgroundColor: Colors.green,
        );
 Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NavigatorPage(
                 
                )));
      } else {
        Fluttertoast.showToast(
          msg: decodedData['error'] ?? "Failed to delete trip",
          backgroundColor: Colors.red,
        );
       
      }
    } catch (e) {
      print("⚠️ Error deleting Trip: $e");
      Fluttertoast.showToast(
        msg: "⚠️ Network error! Please try again.",
        backgroundColor: Colors.red,
      );
    }
  }


  Future<void> _fetchMyprofilePhoto() async {
  setState(() {
    isLoading = true; // Start loading state
  });

  try {
    var fetchMyphotoUrl = Uri.parse(
        "$conn/edit_profile/fetch_trip_banner.php?trip_id=${widget.tripId}");
// print("tri _id"+ widget.tripId);
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


   @override
  void initState() {
    super.initState();
    showStatusBar(); 
    _getUserId();
  
    getWeather();
  

      }

  

  @override
  void dispose() {
    super.dispose();
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
            flexibleSpace:FutureBuilder(
                          future: _fetchMyprofilePhoto(),
            builder: (context, snapshot) {

              return Container(
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
                    : null, // If there's a photo, nothing else is needed here
              );
              

              
            }
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

Spacer(), // This will push the icons apart and center the addphot icon
    GestureDetector(
      onTap: () {
        // Handle add photo action
        _pickImage();
        print("Add Photo Tapped");
      },
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.7), // Light color
        radius: 20,
        child: const Icon(Icons.add_a_photo_outlined, size: 20, color: Colors.black), // Add photo icon
      ),
    ),
                    

Spacer(),
                   PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.7),
                radius: 20,
                child: const Icon(Icons.settings, size: 20, color: Colors.black),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // Handle Edit action
                    break;
                  case 'delete':
                    // Handle Delete action
                     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this trip?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete action here
                var trip_id = widget.tripId;
    _delete_trip(trip_id);
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
                  
                    break;
                 
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                            ],
            ),
              
                  // Center Icon (Photo)
              
                  // Center-Right Icon (Settings)
                  // CircleAvatar(
                  //   backgroundColor: Colors.white.withOpacity(0.7), // Light color
                  //   radius: 20,
                  //   child: const Icon(Icons.delete_forever, size: 25, color: Colors.red),
                  // ),
                  


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
            child:isWeatherLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white70))
            : weatherData == null
                ? Text(weatherError, style: const TextStyle(color: Colors.white70))
                : buildWeatherCard(weatherData!),
// Reusable helper widget:

          ),
          GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExpensesContainer(
          tripId: widget.tripId
        )));
            },
            child: ExpensesContainer(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),

     GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => DocumentsDetailsCard(
          tripId: widget.tripId
        )));
            },
            child: DocumentsDetailsCard(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),
          
          GestureDetector(
            onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => Accommodationdetails(
          tripId: widget.tripId
        )));
            },
            child: Accommodationdetails(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
            ),

          GestureDetector(
             onTap: ( ){
             Navigator.push(
        context, MaterialPageRoute(builder: (context) => TransportationDetails(
          tripId: widget.tripId
        )));
            },
            child: TransportationDetails(
                  tripId: widget.tripId, 
                // Passing tripId to ExpensesContainer

            )
          ),


          GestureDetector(
            onTap: ( ){
              Navigator.push(
        context, MaterialPageRoute(builder: (context) => Tripphotos(
          tripId: widget.tripId
        )));
            },
            child: Tripphotos(
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
     // Function to show the status bar
   void showStatusBar() {
    // Explicitly set overlays to show the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  }
}



  Widget buildWeatherCard(Map<String, dynamic> data) {
    final city = data['name'];
    final temp = data['main']['temp'].toString();
    final feelsLike = data['main']['feels_like'].toString();
    final description = data['weather'][0]['description'];
    final humidity = data['main']['humidity'].toString();
    final wind = data['wind']['speed'].toString();

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1f2f37), Color(0xFF0a1215)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
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
                    const Icon(Icons.wb_sunny_rounded, color: Color(0xFFffd700), size: 28),
                    const SizedBox(width: 10),
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.location_pin, color: Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 5),
                // Main weather info
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$temp°C",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          description[0].toUpperCase() + description.substring(1),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white12),
                // Additional details
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







class ViewTripBannerImagePage extends StatefulWidget {
  final File imageFile;
  final String trip_id;

  ViewTripBannerImagePage({
    required this.imageFile,
    required this.trip_id,
  });

  @override
  State<ViewTripBannerImagePage> createState() => _ViewTripBannerImagePageState();
}

class _ViewTripBannerImagePageState extends State<ViewTripBannerImagePage> {
 Future<void> _uploadImage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('user_id');

  if (userId == null) {
    print("⚠️ User ID not found in SharedPreferences");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User ID not found. Please log in again.')),
    );
    return;
  }

  // Logging trip ID and image path
  print("📦 Trip ID: ${widget.trip_id}");
  print("🖼️ Image Path: ${widget.imageFile.path}");

  var uri = Uri.parse("$conn/edit_profile/change_trip_banner.php");

  var request = http.MultipartRequest('POST', uri);

  request.fields['trip_id'] = widget.trip_id;

  try {
    request.files.add(
      await http.MultipartFile.fromPath('file', widget.imageFile.path),
    );
  } catch (e) {
    print("❌ Failed to attach image file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error attaching image file.')),
    );
    return;
  }

  try {
    print("📡 Sending request to: $uri");
    var response = await request.send();

    var responseData = await response.stream.bytesToString();
    print("📬 Response status: ${response.statusCode}");
    print("📄 Raw Response: $responseData");

    var jsonResponse = json.decode(responseData);
    print("✅ JSON Decoded: $jsonResponse");

    if (response.statusCode == 200 && jsonResponse["status"] == "success") {
      String newImageUrl = jsonResponse["file_url"];
      print("🖼️ New uploaded image URL: $newImageUrl");

      await prefs.setString('profile_image', newImageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
      setState(() {}); // Refresh UI
    } else {
      print("❌ Upload failed with status: ${jsonResponse["status"]}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: ${jsonResponse["message"] ?? "Try again"}')),
      );
    }
  } catch (e) {
    print("❌ Exception during upload: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error uploading image.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        child: Column(
          children: [
            Image.file(
              widget.imageFile,
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _uploadImage();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(color: Colors.amber),
          child: Center(
            child: Text("Upload File"),
          ),
        ),
      ),
    );
  }
}
