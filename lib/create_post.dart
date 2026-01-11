import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cloudinary_service.dart';

class CreatePost extends StatefulWidget {
  final String defaultType; // lost / found from tab
  CreatePost({required this.defaultType});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? image;
  late String type;
  bool anonymous = false;

  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();

  @override
  void initState() {
    super.initState();
    type = widget.defaultType; // 🔹 auto from tab
  }

  Future pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future submit() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      String? imageUrl;

      if (image != null) {
        imageUrl = await uploadToCloudinary(image!);
      }

      await FirebaseFirestore.instance.collection("items").add({
        "title": title.text.trim(),
        "description": description.text.trim(),
        "location": location.text.trim(),
        "type": type,
        "photoUrl": imageUrl,
        "ownerUid": user.uid,
        "ownerEmail": user.email,
        "ownerName": anonymous ? "Anonymous" : (user.displayName ?? "User"),
        "active": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      print("POST ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create ${type.toUpperCase()} Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔹 Title
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Title",
                prefixIcon: Icon(Icons.title),
              ),
            ),

            // 🔹 Description
            TextField(
              controller: description,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),

            // 🔹 Location
            TextField(
              controller: location,
              decoration: InputDecoration(
                labelText: "Location",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            SizedBox(height: 10),

            // 🔹 Anonymous Toggle
            CheckboxListTile(
              value: anonymous,
              title: Text("Post anonymously"),
              onChanged: (v) => setState(() => anonymous = v!),
            ),

            SizedBox(height: 10),

            // 🔹 Image Picker
            image == null
                ? TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Add Image (Optional)"),
                    onPressed: pickImage,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!, height: 160, fit: BoxFit.cover),
                  ),

            SizedBox(height: 25),

            // 🔹 Submit Button
            ElevatedButton(
              onPressed: submit,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text("POST",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}