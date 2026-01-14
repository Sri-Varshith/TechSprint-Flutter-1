import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsPage extends StatelessWidget {
  final DocumentSnapshot doc;
  DetailsPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    final d = doc.data() as Map<String, dynamic>;
    final me = FirebaseAuth.instance.currentUser!.uid == d["ownerUid"];

    return Scaffold(
      appBar: AppBar(title: Text(d["title"])),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (d["photoUrl"] != null)
            Image.network(d["photoUrl"], height: 220, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(d["description"]),
          Text("Location: ${d["location"]}"),
          Divider(),
          Text("Posted by: ${d["ownerName"]}"),
          Text(d["ownerEmail"]),
          Row(children: [
            IconButton(
                icon: Icon(Icons.mail),
                onPressed: () => launchUrl(Uri.parse(
                    "mailto:${d["ownerEmail"]}?subject=Regarding ${d["title"]}"))),
          ]),
          if (me)
            ElevatedButton(
                onPressed: () => doc.reference.update({"active": false}),
                child: Text("Delete"))
        ],
      ),
    );
  }
}