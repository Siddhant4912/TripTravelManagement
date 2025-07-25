import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/connections/conn.dart';

class UserCardContainer extends StatefulWidget {
  final String? card_name;
  final String? card_img;
  final String? user_name;
  final String? trip_id;
  final String? userImg; // ✅ New field

  UserCardContainer({
    Key? key,
    this.card_name,
    this.card_img,
    this.user_name,
    this.trip_id,
    this.userImg, // ✅ Include in constructor
  }) : super(key: key);

  @override
  State<UserCardContainer> createState() => _UserCardContainerState();
}

class _UserCardContainerState extends State<UserCardContainer> {
  int totalExpenses = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalExpensesAndSet();
    _fetchMyprofilePhoto();
  }



  bool isLoading = true;
  String? photoUrl;


  Future<void> _fetchMyprofilePhoto() async {
  setState(() {
    isLoading = true; // Start loading state
  });

  try {
    var fetchMyphotoUrl = Uri.parse(
        "$conn/edit_profile/fetch_trip_banner.php?trip_id=${widget.trip_id}");
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


  Future<int> fetchTotalExpenses(String? tripId) async {
    try {
      final response = await http.get(
        Uri.parse('$conn/MyTrips/fetch_total_expenses.php?trip_id=$tripId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['total_amount'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      return 0;
    }
  }

  void fetchTotalExpensesAndSet() async {
    int expenses = await fetchTotalExpenses(widget.trip_id);
    setState(() {
      totalExpenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: double.infinity,
        height: 230,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 152,
              decoration: BoxDecoration(
               image: DecorationImage(
      image: NetworkImage(
        (photoUrl != null && photoUrl!.isNotEmpty)
            ? photoUrl!
            : "https://images.pexels.com/photos/14653174/pexels-photo-14653174.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      ),
      fit: BoxFit.cover,
      onError: (exception, stackTrace) {
        // This does not show fallback visually; for full fallback, use Image.network with errorBuilder instead.
        debugPrint('❌ Failed to load image: $exception');
      },
    ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: widget.userImg != null &&
                                  widget.userImg!.isNotEmpty
                              ? NetworkImage(widget.userImg!)
                              : null,
                          backgroundColor: Colors.white,
                          child: widget.userImg == null ||
                                  widget.userImg!.isEmpty
                              ? Icon(Icons.person, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.user_name ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        widget.card_name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "₹",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        " Total Expenses: ₹$totalExpenses",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




