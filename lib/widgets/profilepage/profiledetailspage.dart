import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/widgets/blogs/myblogdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = "";
  String lastName = "";
  String username = "";
    bool isLoading = true;
  String? photoUrl;

  String user_id = "";
  // double profileCompletion = 0.6;


 Future<double> profileCompletion() async {
  // Or fetch from your user model

      await Future.delayed(const Duration(milliseconds: 500));


  if (firstName.trim().isEmpty && lastName.trim().isEmpty) {
 
    return 0.6;
  } else {
 
    return 1.0;
  }
}
  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString("user_id") ?? "";

    if (storedUserId.isNotEmpty) {
      setState(() {
        user_id = storedUserId;
      });
      _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {
    final String fetchUrl = "${conn}fetch_user_details.php?user_id=$user_id";

    try {
      final response = await http.get(Uri.parse(fetchUrl));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          firstName = data["first_name"] ?? "";
          lastName = data["last_name"] ?? "";
          username = data["username"] ?? "";
        });
      }
    } catch (error) {
      print("❌ Error fetching user details: $error");
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginPage()), // Ensure LoginPage is correctly defined
      (route) => false,
    ); // This removes all previous routes
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            GestureDetector(
              onTap: () async {
                // Perform logout actions

                logout();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  
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


   


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Column(
                children: [
                 FutureBuilder(
            future: _fetchMyprofilePhoto(),
            builder: (context, snapshot) {
              return Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded Image
                          child: photoUrl != null && photoUrl!.isNotEmpty
                              ? Image.network(
                                  photoUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person,
                                        size: 100, color: Colors.white);
                                  },
                                )
                              : Icon(Icons.person,
                                  size: 100,
                                  color: Colors.white), // Default Icon
                        ),


                        
                       
                      ],
                    );
            }
                    ),

                      const SizedBox(height: 10),
                  FutureBuilder(
                    future: _fetchUserDetails(),
                     builder: (context, snapshot) {
                    return Text(
                      "$firstName $lastName | @$username",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                     }
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ),
                      );
                    },
                    child:  Container(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  decoration: BoxDecoration(
    color: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.blue),
  ),
  child: const Text(
    "Edit Profile",
    style: TextStyle(
      color: Colors.blue,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    ),
  ),
),
                  ),
                  const SizedBox(height: 10),
                  // Profile Completion Progress
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child:FutureBuilder<double>(
//   future: profileCompletion(),
//   builder: (context, snapshot) {
    
//       double progress = snapshot.data!;
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LinearProgressIndicator(
//             value: 0.6,
//             backgroundColor: Colors.grey.shade300,
//             color: progress == 1.0 ? Colors.green : Colors.orange,
//             minHeight: 8,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             progress == 1.0
//                 ? "Your profile is 100% complete."
//                 : "Your profile is ${(progress * 100).toInt()}% complete.",
//             style: const TextStyle(color: Colors.grey, fontSize: 14),
//           ),
//         ],
//       );
   
//   },
// ),

//                   )
                ],
              ),
            ),
                
            const SizedBox(height: 20),

            // Profile Options List
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyBlogFeedPage(),
                    ),
                  );
                },
                child: _buildProfileOption(Icons.star, "My Blog")),
            _buildProfileOption(Icons.luggage, "Saved trips"),
            _buildProfileOption(Icons.people, "Invite Friends"),
  
            GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: _buildProfileOption(Icons.logout, "Logout")),
            _buildProfileOption(Icons.privacy_tip, "Privacy & Policy"),

            const SizedBox(height: 50),
            // App Version
            const Text(
              "Trip Travels",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? photoUrl;

  bool isLoading = true;
  String selectedGender = "Male";
  String? selectedDateOfBirth;
  String user_id = "";
  // String photoUrl = "";

  @override
  void initState() {
    super.initState();
    _getUserId();
    // _loadProfileImage();
  }

  //   Future<void> _loadProfileImage() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _profileImageUrl = prefs.getString('profile_image');
  //   });
  // }

  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString("user_id") ?? "";

    // print("🔹 Fetched User ID: $storedUserId"); // Debugging

    if (storedUserId.isNotEmpty) {
      setState(() {
        user_id = storedUserId;
      });
      _fetchUserDetails();
      _fetchMyprofilePhoto();
    } else {
      setState(() {
        isLoading = false;
      });
      // print("🚨 No user_id found in SharedPreferences!");
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
          builder: (context) => ViewDocumentFilePage(
            imageFile: selectedImage,
          ),
        ),
      );
    }
  }

  Future<void> _fetchUserDetails() async {
    final String fetchUrl = "${conn}fetch_user_details.php?user_id=$user_id";
    // print("🌍 Fetching URL: $fetchUrl"); // Debugging

    try {
      final response = await http.get(Uri.parse(fetchUrl));

      // print("📜 Raw Response: ${response.body}"); // Debugging

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          usernameController.text = data["username"] ?? "";
          firstNameController.text = data["first_name"] ?? "";
          lastNameController.text = data["last_name"] ?? "";
          emailController.text = data["email"] ?? "";
          selectedDateOfBirth = data["dob"] ?? "";
          selectedGender = data["gender"] ?? "Male";
          isLoading = false;
        });

        // print("✅ User details loaded successfully!");
      } else {
        setState(() {
          isLoading = false;
        });
        // print("🚨 No user data found in the response!");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // print("❌ Error fetching user details: $error");
    }
  }

  _update_profile(user_Id) async {
    var updateUrl = Uri.parse(conn + "edit_profile/update_profile.php");

    // print("🔹 Sending request to: $updateUrl");

    var requestBody = {
      "user_id": user_Id,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "gender": selectedGender,
      "dob": selectedDateOfBirth ?? "",
    };

    try {
      var res = await http.post(
        updateUrl,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: requestBody,
      );

      // print("📜 Raw Response: ${res.body}");

      if (res.body.isEmpty) {
        // print("🚨 Empty response from the server!");
        Fluttertoast.showToast(
            msg: "Server error: No response received",
            backgroundColor: Colors.red);
        return;
      }

      var decodedData = json.decode(res.body);
      // print("✅ Decoded Response: $decodedData");

      if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey('status')) {
        if (decodedData['status'] == 'success') {
          Fluttertoast.showToast(
            msg: decodedData['message'],
            backgroundColor: Colors.green,
          );
        } else {
          Fluttertoast.showToast(
            msg: decodedData['message'],
            backgroundColor: Colors.red,
          );
        }
      } else {
        // print("🚨 Unexpected response format!");
        Fluttertoast.showToast(
            msg: "Unexpected response format", backgroundColor: Colors.red);
      }
    } catch (error) {
      // print("❌ Error updating user details: $error");
      Fluttertoast.showToast(
          msg: "Error updating details: $error", backgroundColor: Colors.red);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Edit Profile"),
        backgroundColor: Colors.black,
        actions: [
       ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // Handle save action

                          var user_Id = user_id;
                          print("user_id" + user_id);
                          _update_profile(user_Id);
                        },
                        child: const Text("Save",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
    ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Center(
                    child: FutureBuilder(
            future: _fetchMyprofilePhoto(),
            builder: (context, snapshot) {
              return Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded Image
                          child: photoUrl != null && photoUrl!.isNotEmpty
                              ? Image.network(
                                  photoUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person,
                                        size: 100, color: Colors.white);
                                  },
                                )
                              : Icon(Icons.person,
                                  size: 100,
                                  color: Colors.white), // Default Icon
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            // Handle profile picture change
                            _pickImage();
                          },
                          child: const Text(
                            "Change profile picture",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    );
            }
                    )
                  ),
                  

                  const SizedBox(height: 20),

                  // Input Fields
                  _buildInputField("USERNAME", usernameController),
                  _buildInputField("FIRST NAME", firstNameController),
                  _buildInputField("LAST NAME", lastNameController),
                  _buildInputField("EMAIL ADDRESS", emailController),

                  const SizedBox(height: 10),

                  // Gender Selection
                  const Text("GENDER",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Row(
                    children: ["Female", "Male", "Other"].map((gender) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedGender == gender
                                  ? Colors.green
                                  : Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedGender = gender;
                              });
                            },
                            child: Text(gender,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Date of Birth
                  const Text("DATE OF BIRTH",
                      style: TextStyle(color: Colors.yellow, fontSize: 14)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      selectedDateOfBirth ?? "Input ...",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: const Icon(Icons.warning, color: Colors.yellow),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000, 1, 1),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDateOfBirth =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                  // const SizedBox(height: 20),

                  // Save Changes Button
                  // Center(
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.green,
                  //         padding: const EdgeInsets.symmetric(vertical: 14),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8)),
                  //       ),
                  //       onPressed: () {
                  //         // Handle save action

                  //         var user_Id = user_id;
                  //         print("user_id" + user_id);
                  //         _update_profile(user_Id);
                  //       },
                  //       child: const Text("Save Changes",
                  //           style:
                  //               TextStyle(fontSize: 18, color: Colors.white)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewDocumentFilePage extends StatefulWidget {
  final File imageFile;

  ViewDocumentFilePage({
    required this.imageFile,
  });

  @override
  State<ViewDocumentFilePage> createState() => _ViewDocumentFilePageState();
}

class _ViewDocumentFilePageState extends State<ViewDocumentFilePage> {
  Future<void> _uploadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$conn/edit_profile/change_profile_photo.php"),
    );

    request.fields['user_id'] = userId;
    request.files.add(
      await http.MultipartFile.fromPath('file', widget.imageFile.path),
    );

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse["status"] == "success") {
        String newImageUrl =
            jsonResponse["file_url"]; // ✅ Get new profile image URL

        await prefs.setString(
            'profile_image', newImageUrl); // ✅ Store it locally

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
        setState(() {}); // ✅ Refresh UI to show updated image
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Try again.')),
        );
      }
    } catch (e) {
      // print("❌ Error uploading image: $e");
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
