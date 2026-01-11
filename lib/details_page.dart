import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final DocumentSnapshot doc;
  DetailsPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    final d = doc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(d["title"])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            if (d["photoUrl"] != null)
              Image.network(d["photoUrl"], height: 200),

            Text(d["description"]),
            Text("Location: ${d["location"]}"),
            Divider(),

            Text("Posted by: ${d["ownerName"]}"),
            Text(d["ownerEmail"]),

            ElevatedButton.icon(
              icon: Icon(Icons.mail),
              label: Text("Contact"),
              onPressed: () => launchUrl(Uri.parse(
                  "mailto:${d["ownerEmail"]}?subject=Regarding your post")),
            ),
          ],
        ),
      ),
    );
  }
}