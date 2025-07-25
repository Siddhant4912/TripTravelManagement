import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _emailError = false;
  bool _passError = false;
  bool _usernameError = false;
  _loginPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
_signUp() async {
  if (_username.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please fill all the details",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var signupUrl = Uri.parse(conn + "/signup.php");

  try {
    var response = await http.post(signupUrl, body: {
      "username": _username.text,
      "email": _email.text,
      "password": _password.text,
    });

    var decodedData = json.decode(response.body);

    if (decodedData['status'] == 'Login Success') {
      var username = decodedData['data']['username'];
      var userId = decodedData['data']['user_id'];

      await prefs.setString('username', username);
      await prefs.setString('user_id', userId.toString());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigatorPage()));
    } else {
      Fluttertoast.showToast(
        msg: decodedData['status'],
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Network error. Please try again.",
      backgroundColor: Colors.red,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back2.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/19960783.png",
                    //   height: 200,
                    // ),
                const SizedBox(height: 20),
SizedBox(
  height: 100,
  child: Container(
    alignment: Alignment.center,
    child: Text(
      "Sign Up",
      style: TextStyle(
        color: Color(0xFFFF4901),
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    ),
  ),
),
TextField(
  controller: _username,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    hintText: 'Username',
    prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _usernameError ? Colors.red : Colors.transparent,
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _usernameError ? Colors.red : Colors.deepOrangeAccent,
        width: 2,
      ),
    ),
  ),
),
const SizedBox(height: 15),
TextField(
  controller: _email,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    hintText: 'E-Mail',
    prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _emailError ? Colors.red : Colors.transparent,
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _emailError ? Colors.red : Colors.deepOrangeAccent,
        width: 2,
      ),
    ),
  ),
),
const SizedBox(height: 15),
TextField(
  controller: _password,
  obscureText: true,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    hintText: 'Password',
    prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _passError ? Colors.red : Colors.transparent,
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: _passError ? Colors.red : Colors.deepOrangeAccent,
        width: 2,
      ),
    ),
  ),
),
const SizedBox(height: 30),
 ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child:Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
const SizedBox(height: 15),
Container(
  decoration: BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(25),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  child: TextButton(
    onPressed: _loginPage,
    child: const Text(
      "Already have an account? Login",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
)

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
