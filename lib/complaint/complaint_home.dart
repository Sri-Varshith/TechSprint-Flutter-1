import 'package:flutter/material.dart';
import 'complaint_form.dart';
import 'complaint_status.dart';

class ComplaintHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Smart Complaints"),
          bottom: TabBar(tabs:[
            Tab(text:"My Complaints"),
            Tab(text:"New Complaint")
          ]),
        ),
        body: TabBarView(children:[
          ComplaintStatus(),
          ComplaintForm(),
        ]),
      ),
    );
  }
}