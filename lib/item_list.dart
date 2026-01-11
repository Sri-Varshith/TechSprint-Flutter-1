import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'details_page.dart';

class ItemList extends StatelessWidget {
  final String type;
  ItemList({required this.type});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("items")
          .where(type == "matches" ? "ownerEmail" : "type",
              isEqualTo: type == "matches"
                  ? FirebaseAuth.instance.currentUser!.email
                  : type)
          .where("active", isEqualTo: true)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator());

        final docs = snap.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (d["photoUrl"] != null)
                    Image.network(d["photoUrl"], height: 150, fit: BoxFit.cover),

                  ListTile(
                    title: Text(d["title"]),
                    subtitle: Text(d["description"]),
                    trailing: Text(d["location"]),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text(type == "lost"
                            ? "I FOUND THIS"
                            : "THIS IS MINE"),
                        onPressed: () => openMail(d),
                      ),
                      TextButton(
                        child: Text("VIEW DETAILS"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailsPage(doc: docs[i])));
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void openMail(Map d) async {
    final uri = Uri.parse(
        "mailto:${d["ownerEmail"]}?subject=Regarding your ${d["title"]}");
    await launchUrl(uri);
  }
}