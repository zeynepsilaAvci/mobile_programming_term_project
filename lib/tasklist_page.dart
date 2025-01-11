import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_project/model/todo_model.dart';
import 'package:course_project/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListPage extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task List Page"),
        automaticallyImplyLeading: false,),
      body: Column(
        children: [
          // Yapılmamış görevler
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: _databaseService.todos, // Yapılmamış todo'ları al
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Todo> todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];
                      final DateTime dt = todo.timeStamp.toDate();
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: todo.completed ? TextDecoration.lineThrough : null, // Yapılmışsa üstü çizilir
                            ),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: TextStyle(
                              decoration: todo.completed ? TextDecoration.lineThrough : null, // Yapılmışsa üstü çizilir
                            ),
                          ),
                          trailing: Text(
                            '${dt.day}/${dt.month}/${dt.year}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator(color: Colors.white));
                }
              },
            ),
          ),
          Divider(), // Yapılmamış ve yapılmış görevler arasında bir çizgi
          // Yapılmış görevler
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: _databaseService.completedtodos, // Yapılmış todo'ları al
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Todo> todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];
                      final DateTime dt = todo.timeStamp.toDate();
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: todo.completed ? TextDecoration.lineThrough : null, // Yapılmışsa üstü çizilir
                            ),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: TextStyle(
                              decoration: todo.completed ? TextDecoration.lineThrough : null, // Yapılmışsa üstü çizilir
                            ),
                          ),
                          trailing: Text(
                            '${dt.day}/${dt.month}/${dt.year}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator(color: Colors.white));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
