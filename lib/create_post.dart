import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String type = "lost";
  final title = TextEditingController();
  final desc = TextEditingController();
  final loc = TextEditingController();

  void submit() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("items").add({
      "type": type,
      "title": title.text,
      "description": desc.text,
      "location": loc.text,
      "email": user.email,
      "ownerId": user.uid,
      "active": true,
      "createdAt": FieldValue.serverTimestamp()
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          DropdownButtonFormField(
            value: type,
            items: [
              DropdownMenuItem(value: "lost", child: Text("Lost")),
              DropdownMenuItem(value: "found", child: Text("Found")),
            ],
            onChanged: (v) => setState(() => type = v!),
          ),
          TextField(controller: title, decoration: InputDecoration(labelText: "Title")),
          TextField(controller: desc, decoration: InputDecoration(labelText: "Description")),
          TextField(controller: loc, decoration: InputDecoration(labelText: "Location")),
          SizedBox(height: 20),
          ElevatedButton(onPressed: submit, child: Text("Submit"))
        ]),
      ),
    );
  }
}