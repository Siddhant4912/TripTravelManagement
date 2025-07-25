import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserDocuementPage extends StatefulWidget {
  final String? tripId;
  const UserDocuementPage({required this.tripId, Key? key}) : super(key: key);

  @override
  State<UserDocuementPage> createState() => _UserDocuementPageState();
}

class _UserDocuementPageState extends State<UserDocuementPage> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;




  // Future<void> _pickFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _selectedFile = result.files.first;
  //       //_upload_Image(_selectedFile);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewDocumentFilePage(
  //         selectedfile = _selectedFile;
  //       )));
  //     });
  //     print("Selected File: ${_selectedFile!.name}");
  //   }
  // }


// final ImagePicker _picker = ImagePicker();

// Future<void> _pickImage() async {
//   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     File selectedImage = File(pickedFile.path);
    
//     // Navigate to the ViewImageBeforeUpload screen and pass the image
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewDocumentFilePage(imageFile: selectedImage,tripId: widget.tripId, ),
//       ),
//     );
//   }
// }


  

  // void _showAddDocumentModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: const BoxDecoration(
  //             color: Colors.black,
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "Add Document",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  //               ),
  //               const SizedBox(height: 16),

  //               // File Picker Button
  //               ElevatedButton.icon(
  //                 onPressed: (){
  //                   _pickImage();
  //                 },
  //                 icon: const Icon(Icons.upload_file, color: Colors.white),
  //                 label: const Text("Choose File", style: TextStyle(color: Colors.white)),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.blueGrey,
  //                   minimumSize: const Size(double.infinity, 50),
  //                 ),
  //               ),

  //               if (_selectedFile != null) ...[
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   "Selected: ${_selectedFile!.name}",
  //                   style: const TextStyle(color: Colors.white, fontSize: 14),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //               const SizedBox(height: 16),

  //               // Note Input
  //                           ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


_document_photo_page(){
   Navigator.push(
         context, MaterialPageRoute(builder: (context) => UserDocumentTripPhotos(tripId:widget.tripId!,)));
}

  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        _document_photo_page();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xff0a1215),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.folder, color: Colors.yellow),
                              const SizedBox(width: 10),
                              const Text(
                                "Documents",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              const Padding(
                        padding: EdgeInsets.only(left: 0.8, top: 15,bottom: 15, right: 15),
                        child: CircleAvatar(
                          
                          backgroundColor: Color(0xFF1a2a29),
                          child: Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF01a686), size: 10,),
                        ),
                      ),
                            ],
                          ),
                          // GestureDetector(
                          //   onTap: _showAddDocumentModal,
                          //   child: const CircleAvatar(
                          //     backgroundColor: Color(0xFF1a2a29),
                          //     child: Icon(Icons.add, color: Color(0xFF01a686)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class ViewDocumentFilePage extends StatefulWidget {
//   final File imageFile;
//     final String? tripId;
//   ViewDocumentFilePage({required this.imageFile,this.tripId,});

//   @override
//   State<ViewDocumentFilePage> createState() => _ViewDocumentFilePageState();
// }

// class _ViewDocumentFilePageState extends State<ViewDocumentFilePage> {




// Future<void> _uploadImage() async {      
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? userId = prefs.getString('user_id');

//   if (userId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('User ID not found. Please log in again.')),
//     );
//     return;
//   }

//   if (widget.tripId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Trip ID not found.')),
//     );
//     return;
//   }

//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse("$conn/MyTrips/trip_documents.php"), // ❌ Removed trip_id from URL
//   );

//   // ✅ Send user_id and trip_id as form fields
//   request.fields['user_id'] = userId;
//   request.fields['trip_id'] = widget.tripId.toString(); // Ensure it's a string

//   // ✅ Add the file
//   request.files.add(
//     await http.MultipartFile.fromPath('file', widget.imageFile.path),
//   );

//   try {
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image uploaded successfully')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to upload image. Try again.')),
//       );
//     }
//   } catch (e) {
//     print("❌ Error uploading image: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Error uploading image.')),
//     );
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: Container(
//        child: Column(
//          children: [         
//            Image.file(widget.imageFile,),
//          ],
//        ),
//       ),
//       bottomNavigationBar: GestureDetector(
//         onTap: (){
//           Navigator.pop(context);
//           _uploadImage();
     
//         },
//         child: Container(
//           width: double.infinity,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.amber
//           ),
//           child: Center(
//             child: Text("Upload File"),
//           ),
//         ),
//       ),
//     );
//   }
// }


// Page to display uploaded document photos
class UserDocumentTripPhotos extends StatefulWidget {
  final String tripId;
  const UserDocumentTripPhotos({required this.tripId});

  @override
  State<UserDocumentTripPhotos> createState() => _UserDocumentTripPhotosState();
}

class _UserDocumentTripPhotosState extends State<UserDocumentTripPhotos> {
  List<String> photoUrls = [];
  bool isLoading = true;

 

  Future<void> _fetchTripPhotos() async {

    try {
      print("📡 Fetching trip photos...");

      var fetchMyTripUrl = Uri.parse(
          "http://192.168.27.82/flutter_backend/MyTrips/fetch_document_trip_photos.php?trip_id=${widget.tripId.toString()}");

      var res = await http.get(fetchMyTripUrl);

      print("🔄 Response status: ${res.statusCode}");
      print("📜 Raw Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);

        if (jsonData is List) {
          setState(() {
            photoUrls = jsonData.map((item) => item.toString(), ).toList();
            isLoading = false;
          });

          // Debugging: Print each image URL
          print("🖼️ Fetched ${photoUrls.length} photos:");
          for (String url in photoUrls) {
            print(url);
          }
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Failed to load photos (Status: ${res.statusCode})");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("❌ Error fetching photos: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTripPhotos(); // Ensure it runs when the page loads
  }

  // Future<void> _deleteImage(String imageUrl) async {
  //   try {
  //     Uri uri = Uri.parse(imageUrl);
  //     String fileName = uri.pathSegments.last;

  //     var deleteUrl = Uri.parse(
  //         "http://192.168.27.82/flutter_backend/MyTrips/delete_trip_document.php");

  //     var response = await http.post(deleteUrl, body: {"file_name": fileName});

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         photoUrls.remove(imageUrl);
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Image deleted successfully")),
  //       );
  //     } else {
  //       throw Exception("Failed to delete image.");
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Error deleting image.")),
  //     );
  //     print("❌ Error deleting image: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
                foregroundColor: Colors.white,

        backgroundColor: Colors.black,
        title: const Text("Documents", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : photoUrls.isEmpty
              ? const Center(
                  child: Text("No Photos Available",
                      style: TextStyle(color: Colors.white)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 images per row
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: photoUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // _showFullImage(context, photoUrls[index]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            photoUrls[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.white);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

//   void _showFullImage(BuildContext context, String imageUrl) {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         children: [
//           // Image Viewer
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: InteractiveViewer(
//               child: Image.network(imageUrl, fit: BoxFit.contain),
//             ),
//           ),
          
//           // Delete Icon in the Top-Right Corner
//           // Positioned(
//           //   top: 10,
//           //   right: 10,
//           //   child: IconButton(
//           //     icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
//           //     onPressed: () {
//           //       Navigator.pop(context); // Close the dialog
//           //       _deleteImage(imageUrl); // Call delete function
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     ),
//   );
// }

}
