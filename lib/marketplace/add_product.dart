import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final title = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final description = TextEditingController();
  final imageUrl = TextEditingController();

  Future submit() async {
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection("marketplace").add({
      "title": title.text.trim(),
      "price": int.parse(price.text.trim()),
      "category": category.text.trim(),
      "description": description.text.trim(),
      "imageUrl": imageUrl.text.trim(),
      "sellerName": user.displayName ?? user.email,
      "sellerEmail": user.email,
      "active": true,
      "createdAt": FieldValue.serverTimestamp()
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: price, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: category, decoration: const InputDecoration(labelText: "Category")),
            TextField(controller: description, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: imageUrl, decoration: const InputDecoration(labelText: "Image URL")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: const Text("Post Product"))
          ],
        ),
      ),
    );
  }
}