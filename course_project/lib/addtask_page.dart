import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Center(child: Text("Add Task Content")),
    );
  }
}