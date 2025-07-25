import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _emailError = false;
  bool _passError = false;

  _login() async {
    setState(() {
      _emailError = _email.text.isEmpty;
      _passError = _pass.text.isEmpty;
    });

    if (_emailError || _passError) {
      Fluttertoast.showToast(
        msg: "Please fill  all details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginurl = Uri.parse("$conn/login.php");
    var res = await http.post(loginurl, body: {
      "username": _email.text,
      "password": _pass.text
    }).then((response) async {
      print(response.body);
      var decodeddata = json.decode(response.body);

      if (decodeddata['status'] == 'Login Success') {
        var username = decodeddata['data']['username'];
        var userId = decodeddata['data']['user_id'];
        await prefs.setString('username', username);
        await prefs.setString('user_id', userId);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavigatorPage()));
      } else {
        Fluttertoast.showToast(
            msg: decodeddata['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back3.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                SizedBox(height: 150,
                  child: Container(
                    child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: String.fromCharCode(2)),)
                  ),
                ),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'E-Mail',
                      prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _emailError ? Colors.red : Colors.transparent, 
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _emailError ? Colors.red : Colors.blueAccent, 
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _passError ? Colors.red : Colors.transparent, 
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: _passError ? Colors.red : Colors.blueAccent, 
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}