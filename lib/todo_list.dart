import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart';
import 'package:intl/intl.dart';


class TodoList extends StatelessWidget {
  final List<Person> todos;

  const TodoList(this.todos);

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(
        child: Text('没有数据！',style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,

        ),),
      );
    } else {
      return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          var todo = todos[index];
          return _buildTodo(todo);
        },
      );
    }
  }

  Widget _buildTodo(Person todo) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("序号:${todo.key}",

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                Text('姓名:${todo.name}   时间:'
                  '${DateFormat("yyyy-MM-dd HH:mm:ss").format(todo.created)}   年龄:${todo.age}   朋友圈:'
                      '${todo.friends}',
                  style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              iconSize: 30,
              icon: Icon( Icons.add),
              onPressed: () {
                todo.age = todo.age+1;
                todo.save();
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.delete),
              onPressed: () {
                todo.delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}