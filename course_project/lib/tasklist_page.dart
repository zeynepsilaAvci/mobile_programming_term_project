import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task List Page")),
      body: Center(child: Text("Task List Content")),
    );
  }
}