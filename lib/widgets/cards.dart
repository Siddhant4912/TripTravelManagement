import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/tripDetails/expensesDetails.dart';
import 'package:flutter_application_1/widgets/tripDetails/mytripdetails.dart';
import 'package:http/http.dart' as http;

class CardContainer extends StatefulWidget {

    var card_name;

  var tripId;

  

  CardContainer({Key? key, this.card_name, this.tripId}) : super(key: key);

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {

// _myTripdetail() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => CreateExpensePage()));
//   }
 bool isLoading = true;
  String? photoUrl;


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
    _fetchMyprofilePhoto();
      }



  @override
  Widget build(BuildContext context) {
    return  Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              Container(
  height: 180,
  decoration: BoxDecoration(
    image: DecorationImage(
      image: photoUrl != null
          ? NetworkImage(photoUrl!)
          : const NetworkImage(
              "https://images.pexels.com/photos/14653174/pexels-photo-14653174.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            ),
      fit: BoxFit.cover,
    ),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
  ),

),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.card_name,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      
    );
  }
}