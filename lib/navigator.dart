import 'dart:convert';
import 'dart:ffi';

// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/widgets/blogs/users_blog_page.dart';
import 'package:flutter_application_1/widgets/profilepage/profiledetailspage.dart';
import 'package:flutter_application_1/widgets/users/userHomePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);



  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {

   int _selectedIndex = 0;


var username = "";
var user_id = "";
    bool isLoading = true;
  String? photoUrl;




  Future<void> _fetchMyprofilePhoto() async {
    try {
      var fetchMyphotoUrl = Uri.parse(
          "$conn/edit_profile/fetch_profile_photo.php?user_id=$user_id"); // Use correct IP

      var res = await http.get(fetchMyphotoUrl);

      // print("🔄 Response status: ${res.statusCode}");
      // print("📜 Raw Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);

        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey("photo_url")) {
          setState(() {
            photoUrl = jsonData["photo_url"]; // ✅ Fetch only one URL
            isLoading = false;
          });

          // print("🖼️ Fetched Photo URL: $photoUrl");
        } else {
          throw Exception("Invalid JSON format: Expected a single photo URL");
        }
      } else {
        throw Exception("Failed to load photo (Status: ${res.statusCode})");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print("❌ Error fetching photo: $e");
    }
  }
_getusername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
      
      username = prefs.getString('username').toString();
      user_id = prefs.getString('user_id').toString();


      _fetchMyprofilePhoto();
    });
}
  
  static List<Widget> _widgetOptions = <Widget>[
    
    const HomePage(),
    const Userhomepage(),

    BlogFeedPage(),
     ProfilePage(),
   
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
  }

  appbarfunction(){
    if(_selectedIndex == 0){
      _fetchMyprofilePhoto();
        return AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(username, style: TextStyle(color: Colors.white),),
       leading: Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 10, bottom: 8.0,right: 8.0),
    child:  ClipRRect(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded Image
                          child: photoUrl != null && photoUrl!.isNotEmpty
                              ? Image.network(
                                  photoUrl!,
                                  
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person,
                                        size: 100, color: Colors.white);
                                  },
                                )
                              : Icon(Icons.person,
                                  // size: 100,
                                  color: Colors.white), // Default Icon
                        ),
  ),

actions: [
  IconButton(
    icon: Icon(Icons.settings),
    onPressed: () {
      // Handle settings tap here
      // For example, navigate to settings screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    },
  ),
],
      );
    }
    else if(_selectedIndex == 1){
        return AppBar(
          automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text("Explore Trips",),
      );
 
    }
   
    else if(_selectedIndex == 2){
     
        return AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text("Feed"),
      );
    
    }
   
  }


 _logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
  await prefs.remove('username');
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
  print("Logout");
 }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   _getusername();
   _fetchMyprofilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     
      
      appBar: appbarfunction(),







      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

        bottomNavigationBar: Theme(
    data: Theme.of(context).copyWith(
    splashColor: Colors.transparent, // Remove splash effect
    highlightColor: Colors.transparent, // Remove highlight effect
    hoverColor: Colors.transparent, // Remove hover effect (for web)
  ),
          child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFF090a05),
          
          onTap: _onItemTapped,
          selectedItemColor:  Color(0xFF01a686), // Active tab color
          unselectedItemColor: Colors.grey, // Inactive tab color
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
                 
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          ),
        ),
    );
  }
}