import 'package:flutter/material.dart';
import 'item_list.dart';
import 'create_post.dart';
import 'auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FindIt AI"),
          bottom: TabBar(tabs: [
            Tab(text: "Lost"),
            Tab(text: "Found"),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => CreatePost()));
          },
        ),
        body: TabBarView(children: [
          ItemList(type: "lost"),
          ItemList(type: "found"),
        ]),
      ),
    );
  }
}