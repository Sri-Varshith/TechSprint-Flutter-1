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

        if (docs.isEmpty) {
          return Center(child: Text("No items found"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final photo = d["photoUrl"];

            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.all(12),
              height: 160,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(16)),
                          color: Colors.grey.shade200,
                        ),
                        child: photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(16)),
                                child: Image.network(photo,
                                    fit: BoxFit.cover),
                              )
                            : Icon(Icons.image, size: 60),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d["title"] ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 6),
                                Text(d["description"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Spacer(),
                                Row(children: [
                                  Icon(Icons.location_on, size: 14),
                                  SizedBox(width: 4),
                                  Expanded(
                                      child: Text(d["location"] ?? "")),
                                ]),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: Text("View Details"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => DetailsPage(
                                                  doc: docs[i])));
                                    },
                                  ),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}