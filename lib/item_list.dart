import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemList extends StatelessWidget {
  final String type;
  ItemList({required this.type});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email;

    final stream = type == "matches"
        ? FirebaseFirestore.instance
            .collection("items")
            .where("ownerEmail", isEqualTo: email)
            .where("active", isEqualTo: true)
            .snapshots()
        : FirebaseFirestore.instance
            .collection("items")
            .where("type", isEqualTo: type)
            .where("active", isEqualTo: true)
            .snapshots();

    return StreamBuilder(
      stream: stream,
      builder: (_, snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator());

        final docs = snap.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final photo = d["photoUrl"];

            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailsPage(doc: docs[i]))),
              child: Card(
                margin: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: photo != null
                          ? Image.network(photo, fit: BoxFit.cover)
                          : Icon(Icons.image, size: 60),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d["title"],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text(d["description"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: 6),
                              Row(children: [
                                Icon(Icons.location_on, size: 14),
                                Text(d["location"]),
                              ]),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text("View Details",
                                    style:
                                        TextStyle(color: Colors.blueAccent)),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}