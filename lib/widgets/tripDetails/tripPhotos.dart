import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/connections/conn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Tripphotos extends StatefulWidget {
  final String? tripId;

  const Tripphotos({required this.tripId, Key? key}) : super(key: key);

  

  @override
  State<Tripphotos> createState() => _TripphotosState();
}

class _TripphotosState extends State<Tripphotos> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    for (File image in _selectedImages) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$conn/MyTrips/trip_photos.php"),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );


      request.fields['trip_id'] = widget.tripId!;  
    request.fields['user_id'] = userId;

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Try again.')),
        );
      }
    }
  }

  void _showAddDocumentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Documents",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text("Choose Files", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedImages.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: _selectedImages
                        .map((image) => Image.file(image, width: 80, height: 80, fit: BoxFit.cover))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed:(){
            _uploadImages();
                    Navigator.pop(context);
                  } ,

                  child: const Text("Upload Files"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
_trip_photo_page(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripPhotosPage(
          trip_id:widget.tripId,
        )));
}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _trip_photo_page();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0,left: 8.0, right: 8.0),
        child: Card(
          elevation: 0,
          color: Color(0xFF1A1A1A),
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
                              Icon(Icons.photo, color: Color(0xFFFF3333)),
                              const SizedBox(width: 10),
                              const Text(
                                "Photos",
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
                          GestureDetector(
                            onTap: _showAddDocumentModal,
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFF0a1927),
                              child: Icon(Icons.add, color: Color(0xFFae15f8)),
                            ),
                          ),
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


class TripPhotosPage extends StatefulWidget {
  final String? trip_id;
  const TripPhotosPage({required this.trip_id, Key? key}) : super(key: key);
  

  @override
  State<TripPhotosPage> createState() => _TripPhotosPageState();
}
class _TripPhotosPageState extends State<TripPhotosPage> {
  List<String> photoUrls = []; // Stores fetched image URLs
  bool isLoading = true; // Controls loading indicator

  

  Future<void> _fetchTripPhotos() async {

    try {
      print("📡 Fetching trip photos...");

      var fetchMyTripUrl = Uri.parse(
          "$conn/MyTrips/fetch_trip_photos.php?trip_id=${widget.trip_id.toString()}");

      var res = await http.get(fetchMyTripUrl);

      print("🔄 Response status: ${res.statusCode}");
      print("📜 Raw Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);

        if (jsonData is List) {
          setState(() {
            photoUrls = jsonData.map((item) => item.toString()).toList();
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



 Future<void> _deleteImage(String imageUrl) async {
  try {
    // Extract the file name from the full image URL
    Uri uri = Uri.parse(imageUrl);
    String fileName = uri.pathSegments.last;

    print("🧩 Deleting image file: $fileName");

    // Your backend endpoint
    var deleteUrl = Uri.parse("$conn/MyTrips/delete_trip_photos.php");

    // Make POST request to delete image
    var response = await http.post(deleteUrl, body: {"file_name": fileName});

    print("📨 Server response: ${response.body}");

    // Decode JSON response
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
      // ✅ Remove image from the list shown in UI
      setState(() {
        photoUrls.remove(imageUrl);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Image deleted successfully")),
      );
    } else {
      // ❌ Backend returned an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ ${jsonResponse['message']}")),
      );
    }
  } catch (e) {
    print("❌ Error deleting image: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Error deleting image.")),
    );
  }
}
  @override
  void initState() {
    super.initState();
    _fetchTripPhotos(); // Ensure it runs when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text("Trip Photos", style: TextStyle(color: Colors.white)),
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
                          _showFullImage(context, photoUrls[index]);
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

  void _showFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Image Viewer
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
          
          // Delete Icon in the Top-Right Corner
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _deleteImage(imageUrl); // Call delete function
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}