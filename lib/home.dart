import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'item_list.dart';
import 'create_post.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onTheme;
  HomeScreen({required this.onTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tab;
  bool myLost = false;
  bool myFound = false;

  @override
  void initState() {
    super.initState();
    tab = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.search),
          SizedBox(width: 6),
          Text("FindIt AI"),
        ]),
        actions: [
          Icon(Icons.notifications),
          SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: tab,
          tabs: const [
            Tab(text: "Lost"),
            Tab(text: "Found"),
            Tab(text: "Matches"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName ?? "User"),
            accountEmail: Text(user.email ?? ""),
          ),
          ListTile(title: Text("My Matches")),
          ListTile(title: Text("Future Improvements")),
          ListTile(
              title: Text("Theme"),
              trailing: Switch(value: false, onChanged: (_) => widget.onTheme())),
          ListTile(
              title: Text("Logout"),
              onTap: () => FirebaseAuth.instance.signOut()),
        ]),
      ),
      body: TabBarView(controller: tab, children: [
        ItemList(type: "lost"),
        ItemList(type: "found"),
        ItemList(type: "matches"),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final t = tab.index == 0 ? "lost" : "found";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CreatePost(defaultType: t)));
        },
      ),
    );
  }
}