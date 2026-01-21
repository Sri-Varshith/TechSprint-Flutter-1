import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatelessWidget {
  final DocumentSnapshot doc;
  const ProductDetail({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final d = doc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(d["title"])),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (d["imageUrl"] != null)
            Image.network(d["imageUrl"],
                height: 250, fit: BoxFit.cover),

          const SizedBox(height: 20),

          Text(d["title"],
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          Text("₹ ${d["price"]}",
              style: const TextStyle(
                  fontSize: 20, color: Colors.green)),

          const SizedBox(height: 12),

          Text(d["description"] ?? ""),

          const SizedBox(height: 20),

          const Text("Seller",
              style: TextStyle(fontWeight: FontWeight.bold)),

          Text(d["sellerName"] ?? ""),
          Text(d["sellerEmail"] ?? ""),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.mail),
            label: const Text("Contact Seller"),
            onPressed: () {
              launchUrl(Uri.parse(
                  "mailto:${d["sellerEmail"]}?subject=Interested in ${d["title"]}"));
            },
          )
        ],
      ),
    );
  }
}