import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/trip_categories.dart';
import 'package:http/http.dart' as http;

class PopularCategoriesContainer extends StatefulWidget {
  var cat_name;
  var cat_img;
  var cat_id;

  PopularCategoriesContainer({Key? key, this.cat_img, this.cat_name, this.cat_id}) : super(key: key);

  @override
  State<PopularCategoriesContainer> createState() => _PopularCategoriesContainerState();
}

class _PopularCategoriesContainerState extends State<PopularCategoriesContainer> {


  int? totalTrips;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTotalTrips();
  }

 Future<void> fetchTotalTrips() async {
  try {
    final url = "$conn/Fetch_All_Trips/total_trips.php?category=${widget.cat_id}";
    print("Fetching from: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalTrips = data['total_trips'];
        isLoading = false;
      });
    } else {
      print("Failed to load data: ${response.statusCode}");
      setState(() => isLoading = false);
    }
  } catch (e) {
    print("Error fetching data: $e");
    setState(() => isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return        GestureDetector(
      onTap: (){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoriesWiseTripData()),
      );
      },
      child: Card(
        // color: Color.fromARGB(255, 243, 39, 39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: 140,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(widget.cat_img),
                                          fit: BoxFit.cover),
                                      // color: Colors.red,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            
                                            bottomRight: Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:8.0,bottom: 0,top: 8.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,                 
                                        children: [
                                          Container(
                                            child: Text(
                                              widget.cat_name,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600, color: Colors.white)
                                            ),
                                          ),
                                          Container(
                                          
                                            child: Row(
                                              children: [
                                             
                            Text(
                              isLoading
                                  ? "..."
                                  : totalTrips?.toString() ?? "0",
                              style: const TextStyle(color: Colors.white),
                            ),
                              const SizedBox(width: 4),
                            const Text(
                              "Trips",
                              style: TextStyle(color: Colors.white),
                            ),
                                               
                                               
                                              ],
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
                        
      ),
    );
  }
}