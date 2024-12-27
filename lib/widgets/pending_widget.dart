import 'package:course_project/model/todo_model.dart';
import 'package:course_project/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseService _databaseService = DatabaseService();
  @override
  void initState(){
    uid = FirebaseAuth.instance.currentUser! .uid;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: _databaseService.todos,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<Todo> todos = snapshot.data! ;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index){
            Todo todo =todos[index];
            final DateTime dt= todo.timeStamp.toDate();
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Slidable(
                key:ValueKey(todo.id),
                endActionPane: ActionPane(motion: DrawerMotion(),
                    children: [

                      SlidableAction(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.done,
                          label: "Done",
                          onPressed: (context){
                        _databaseService.updateTodoStatus(todo.id, true);
                      })
                    ]),
                startActionPane: ActionPane(motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: "Delete",
                          onPressed: (context) async{
                           await _databaseService.deleteTodoStatus(todo.id);
                          })
                    ]),
                child:ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    todo.description,
                  ),
                  trailing: Text(
                    '${dt.day}/${dt.month}/${dt.year}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            );
          }
        );
        } else{
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      }
    );
  }
}
