import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'details_page.dart';

class ItemList extends StatefulWidget {
  final String type;
  ItemList({required this.type});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool onlyMine = false;

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email;

    Query query = FirebaseFirestore.instance
        .collection("items")
        .where("type", isEqualTo: widget.type)
        .where("active", isEqualTo: true);

    if (onlyMine) {
      query = query.where("ownerEmail", isEqualTo: email);
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Text("My Posts",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Switch(value: onlyMine, onChanged: (v) {
                setState(() => onlyMine = v);
              })
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder(
            stream: query.snapshots(),
            builder: (_, snap) {
              if (!snap.hasData)
                return Center(child: CircularProgressIndicator());

              final docs = snap.data!.docs;

              if (docs.isEmpty)
                return Center(child: Text("No posts found"));

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final d = docs[i].data() as Map<String, dynamic>;
                  final photo = d["photoUrl"];

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsPage(doc: docs[i]),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, 10),
                              color: Colors.black.withOpacity(0.08))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (photo != null)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                              child: Image.network(photo,
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            ),

                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d["title"] ?? "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),

                                SizedBox(height: 10),

                                Text(d["description"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey)),

                                SizedBox(height: 16),

                                Row(children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 6),
                                  Text(d["location"] ?? "")
                                ]),

                                SizedBox(height: 16),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.indigo,
                                        Colors.purple
                                      ]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text("View Details",
                                        style: TextStyle(
                                            color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}