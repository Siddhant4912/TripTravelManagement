import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:flutter_application_1/widgets/blogs/myblogdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BlogFeedPage extends StatefulWidget {
  const BlogFeedPage({Key? key}) : super(key: key);

  @override
  State<BlogFeedPage> createState() => _BlogFeedPageState();
}

class _BlogFeedPageState extends State<BlogFeedPage> {
  List<Map<String, dynamic>> blogs = [];
  bool isLoading = true;
  String? photoUrl;
  String errorMessage = "";
  String user_id = "";

  @override
  void initState() {
    super.initState();
    // fetchBlogs();
    // _fetchMyprofilePhoto();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString("user_id") ?? "";

    // print("🔹 Fetched User ID: $storedUserId"); // Debugging

    if (storedUserId.isNotEmpty) {
      setState(() {
        user_id = storedUserId;
      });
      fetchBlogs();
      _fetchMyprofilePhoto();
    } else {
      setState(() {
        isLoading = false;
      });
      // print("🚨 No user_id found in SharedPreferences!");
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
      print("❌ Error fetching photo: $e");
    }
  }

  Future<void> fetchBlogs() async {
    final String url = (conn + "/user_blogs/fetch_users_blogs.php");
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          blogs = data
              .map((item) => {
                    "blog_id": item["blog_id"] ?? "unknown",
                    "user_id": item["user_id"] ?? "Unknown",
                    "username": item["username"] ?? "Unknown",
                    "blog_title": item["blog_title"] ?? "No Title",
                    "short_description": item["short_description"] ?? "N/A",
                    "blog_content": item["blog_content"] ?? "N/A",
                    "profile_image": item["profile_image"] != null &&
                            item["profile_image"] != "unknown"
                        ? "$conn/images/profile_image/${item['profile_image']}"
                        : "$conn/images/profile_image/default_profile.png",
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load blogs";
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090a05),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : blogs.isEmpty
                ? Center(
                    child: Text(errorMessage.isNotEmpty
                        ? errorMessage
                        : "No blogs found"))
                : ListView.builder(
                    // padding: const EdgeInsets.all(10),
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color(0xff1c1c1e),
        
                        elevation: 0.8,
                        // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: Container(
                            
                            padding: EdgeInsets.all(3), // Border thickness
                            child: CircleAvatar(
                              radius: 32, // Inner avatar size
                              backgroundColor:
                                  Colors.white, // Background inside border
                              child: CircleAvatar(
                                radius: 30, // Actual image avatar
                                backgroundImage: NetworkImage(blog[
                                    'profile_image']), // Replace with actual image URL
                                backgroundColor:
                                    Colors.grey.shade300, // Fallback color
                              ),
                            ),
                          ),
                          title: Text(blog["blog_title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("By ${blog["username"]}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey)),
                              const SizedBox(height: 5),
                              Text(
                                blog["short_description"] ?? "No description",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.green),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailPage(
                                blogTitle: blog["blog_title"],
                                username: blog["username"],
                                short_description: blog["short_description"],
                                content: blog["blog_content"],
                                blogId : blog["blog_id"]
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 16, 101, 172),
              Color.fromARGB(255, 235, 63, 16)
            ], // Sunset Glow Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle, // Ensures the gradient container is circular
        ),
        child: FloatingActionButton(
          onPressed: () {
            print("Floating Button Clicked! Navigate to Add Blog Page");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBlogPage()),
            );
          },
          backgroundColor: Colors.transparent, // Transparent to show gradient
          elevation: 0, // Removes shadow to blend with gradient
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

class BlogDetailPage extends StatefulWidget {
  final String blogId;
  final String blogTitle;
  final String username;
  final String content;
  final String short_description;

  const BlogDetailPage({
    Key? key,
    required this.blogId,
    required this.blogTitle,
    required this.username,
    required this.content,
    required this.short_description,
  }) : super(key: key);

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.blogTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    //         GestureDetector(
    //           onTap: () {
    //             (
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text("Confirm Delete"),
    //       content: const Text("Are you sure you want to delete this trip?"),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //           child: const Text("Cancel"),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             // Perform the delete action here
    //             var blog_id = widget.blogId;
    // deleteBlog(blog_id);
    //             Navigator.of(context).pop(); // Close the dialog after deleting
    //           },
    //           child: const Text(
    //             "Delete",
    //             style: TextStyle(color: Colors.red),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );

    //           },


    //             child:  Icon(Icons.delete_forever_outlined, color: Colors.white, size: 30),

    //         )
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "By ${widget.username}",
              style: TextStyle(
                color: const Color.fromARGB(255, 197, 197, 197),
                fontSize: 18,
              ),
            ),
            const Divider(),
            Text(
              "Description:-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 50,
              child: Text(
                widget.short_description,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Content:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.content,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),




      
    );
  }
}
class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isSubmitting = false;
  bool isLoading = true; // ✅ Added loading state
  String username = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    try {
      print("🔄 Fetching username from SharedPreferences...");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUsername = prefs.getString('username');
      String? storedUserId = prefs.getString('user_id');

      if (storedUsername == null || storedUserId == null) {
        print("❌ Username or user ID not found! Setting default values.");
        storedUsername = "Guest";
        storedUserId = "0";
      }

      print("✅ Fetched Username: $storedUsername");
      print("✅ Fetched User ID: $storedUserId");

      setState(() {
        username = storedUsername!;
        userId = storedUserId!;
        isLoading = false; // Stop loading after getting data
      });
    } catch (e) {
      print("🚨 Error fetching username: $e");
      setState(() {
        isLoading = false; // Prevent infinite loading
      });
    }
  }

  Future<void> _submitBlog() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final url = Uri.parse(conn + "user_blogs/create_blog.php");

    print("🌍 Sending API Request to: $url");
    print("📩 Sending Data: user_id=$userId, user_name=$username");

    try {
      final response = await http.post(
        url,
        body: {
          "user_id": userId,
          "username": username,
          "blog_title": titleController.text,
          "short_description": descriptionController.text,
          "blog_content": contentController.text,
        },
      );

      print("✅ API Response Code: ${response.statusCode}");
      print("📨 API Response Body: ${response.body}");

      setState(() {
        isSubmitting = false;
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Blog added successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add blog! Try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting blog!")),
        );
      }
    } catch (e) {
      print("🚨 API Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error! Check your connection.")),
      );
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF090a05),
      appBar: AppBar(
        title: Text("Add New Blog"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading // ✅ Show loading until username is fetched
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Blog Title",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter a title"
                            : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Short Description",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter a description"
                            : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: contentController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: "Blog Content",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter blog content"
                            : null,
                      ),
                      SizedBox(height: 20),
                      isSubmitting
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitBlog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text(
                                "Add Blog",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
