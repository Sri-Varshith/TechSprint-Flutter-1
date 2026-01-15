import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesTab extends StatelessWidget {
  final List matches;
  MatchesTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: matches.length,
      itemBuilder: (_, i) {
        final m = matches[i];
        final d = m["doc"].data();

        final score = m["score"];
        final label = score >= 0.75 ? "High Match" : "Medium Match";
        final color = score >= 0.75 ? Colors.green : Colors.orange;

        return Container(
          margin: EdgeInsets.only(bottom: 24),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.08))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(label,
                        style: TextStyle(color: color)),
                  ),
                  Spacer(),
                  Text("${(score * 100).toInt()}%")
                ],
              ),

              SizedBox(height: 16),

              if (d["photoUrl"] != null)
                ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(d["photoUrl"], height: 160, fit: BoxFit.cover)),

              SizedBox(height: 16),

              Text(d["title"],
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

              SizedBox(height: 12),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(m["reason"]),
              )
            ],
          ),
        );
      },
    );
  }
}