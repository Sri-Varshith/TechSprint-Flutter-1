import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gemini_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchView extends StatelessWidget {
  final String itemId;
  MatchView(this.itemId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Matches")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (c, s) {
          if (!s.hasData) return Center(child: CircularProgressIndicator());

          final docs = s.data!.docs;

          return ListView(
            children: docs.map((d) {
              return FutureBuilder(
                future: match("dummy", d["description"]),
                builder: (c, snap) {
                  if (!snap.hasData) return SizedBox();

                  final m = snap.data!;
                  if (m["similarity_score"] < 0.6) return SizedBox();

                  return Card(
                    child: ListTile(
                      title: Text(d["title"]),
                      subtitle: Text(m["reasoning"]),
                      trailing: Text("${(m["similarity_score"]*100).toInt()}%"),
                      onTap: () => launchUrl(Uri.parse("mailto:${d["email"]}")),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}