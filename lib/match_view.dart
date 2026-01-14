import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gemini_service.dart';

class MatchView extends StatefulWidget {
  final DocumentSnapshot item;
  MatchView(this.item);

  @override
  _MatchViewState createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  bool loading = true;
  List matches = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future fetch() async {
    final snap = await FirebaseFirestore.instance
        .collection("items")
        .where("active", isEqualTo: true)
        .get();

    for (var d in snap.docs) {
      final r = await match(widget.item["description"], d["description"]);
      final s = r["similarity_score"];
      if (s >= 0.4) {
        matches.add({
          "doc": d,
          "score": s,
          "reason": r["reasoning"]
        });
      }
    }

    setState(() => loading = false);
  }

  String label(double s) => s >= 0.6 ? "High" : "Medium";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Matches")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: matches.map((m) {
                final d = m["doc"].data();
                return Card(
                  margin: EdgeInsets.all(12),
                  child: Column(children: [
                    if (d["photoUrl"] != null)
                      Image.network(d["photoUrl"], height: 150),
                    ListTile(
                      title: Text(d["title"]),
                      subtitle: Text(m["reason"]),
                      trailing: Column(children: [
                        Text("${(m["score"] * 100).toInt()}%"),
                        Text(label(m["score"]))
                      ]),
                    )
                  ]),
                );
              }).toList(),
            ),
    );
  }
}