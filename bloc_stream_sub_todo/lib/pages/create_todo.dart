import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _todoController,
      decoration: const InputDecoration(
        label: Text('What to do?'),
      ),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoListBloc>().add(
                AddTodoEvent(todoDesc: todoDesc),
              );
          _todoController.clear();
        }
      },
    );
  }
}
