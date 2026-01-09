import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'match_view.dart';

class ItemList extends StatelessWidget {
  final String type;
  ItemList({required this.type});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("items")
          .where("type", isEqualTo: type)
          .where("active", isEqualTo: true)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final d = docs[i];
            return Card(
              child: ListTile(
                title: Text(d["title"]),
                subtitle: Text(d["description"]),
                trailing: Text(d["location"]),
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MatchView(d.id))),
              ),
            );
          },
        );
      },
    );
  }
}