import 'package:flutter/material.dart';

import 'create_todo.dart';
import 'search_and_filter.dart';
import 'show_todos.dart';
import 'todo_header.dart';

class TodosPages extends StatelessWidget {
  const TodosPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: Column(
          children: [
            TodoHeader(),
            CreateTodo(),
            SizedBox(height: 10),
            SearchAndFilter(),
            ShowTodos(),
          ],
        ),
      )),
    );
  }
}
