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
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(d["title"] ?? ""),
              background: d["photoUrl"] != null
                  ? Image.network(d["photoUrl"], fit: BoxFit.cover)
                  : Container(color: Colors.grey),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if ((d["description"] ?? "").toString().isNotEmpty)
                    Text(d["description"], style: TextStyle(fontSize: 16)),

                  if ((d["location"] ?? "").toString().isNotEmpty) ...[
                    SizedBox(height: 20),
                    Row(children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 6),
                      Text(d["location"])
                    ])
                  ],

                  SizedBox(height: 24),

                  Text("Posted By",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),

                  SizedBox(height: 8),

                  Text(d["ownerName"] ?? "Unknown"),
                  Text(d["ownerEmail"] ?? ""),

                  SizedBox(height: 20),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.indigo,
                    ),
                    icon: Icon(Icons.mail),
                    label: Text("Contact"),
                    onPressed: () => launchUrl(Uri.parse(
                        "mailto:${d["ownerEmail"]}?subject=Regarding ${d["title"]}")),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}