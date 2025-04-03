import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0; // To track the selected tab


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    UploadImageScreen(),  // First screen for image upload
    RetrieveImagesScreen() // Second screen for retrieving images
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CloudVault"), backgroundColor: Colors.deepPurple),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Retrieve"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  String? _binaryString;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);

      setState(() {
        _image = imageFile;
        _binaryString = base64String;
      });

      await _uploadImageToFirestore(base64String);
    }
  }

  Future<void> _uploadImageToFirestore(String base64Image) async {
    try {
      String uid = _auth.currentUser!.uid;

      await _firestore.collection("users").doc(uid).update({
        "images": FieldValue.arrayUnion([base64Image]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
              : Text("No image selected"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImage,
            child: Text("Pick Image from Gallery"),
          ),
          SizedBox(height: 20),
          _binaryString != null
              ? SelectableText("Base64 Length: ${_binaryString!.length}")
              : Container(),
        ],
      ),
    );
  }
}

class RetrieveImagesScreen extends StatefulWidget {
  const RetrieveImagesScreen({super.key});

  @override
  State<RetrieveImagesScreen> createState() => _RetrieveImagesScreenState();
}

class _RetrieveImagesScreenState extends State<RetrieveImagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _getImagesFromFirestore() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      List<dynamic>? images = (userDoc.data() as Map<String, dynamic>)["images"];
      return images != null ? List<String>.from(images) : [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getImagesFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No images available"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(base64Decode(snapshot.data![index]), height: 200, width: 200,),
            );
          },
        );
      },
    );
  }
}
