import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

_splash() async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('user_id');

  if(userId != null){
    print("Login : $userId");
     Timer(const Duration(seconds: 2), (){
     
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>NavigatorPage()));

    });
  }
  else{
    print("Not Login");
    Timer(const Duration(seconds: 1), (){
     
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginPage()));

     });
  }


    
}



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splash();
  }



 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Colors.black,  // Set background color here
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/19960783.png",
            height: 500,
          ),
        ],
      ),
    ),
  );
}

}

