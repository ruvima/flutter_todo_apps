import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo_list/todo_list_bloc.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _editingController = TextEditingController();
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _editingController,
      decoration: const InputDecoration(
        label: Text('What to do?'),
      ),
      onSubmitted: (String? desc) {
        if (desc != null) {
          context.read<TodoListBloc>().add(AddTodoEvent(desc: desc));
          _editingController.clear();
        }
      },
    );
  }
}
