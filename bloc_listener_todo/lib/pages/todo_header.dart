import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/active_todo_count/active_todo_count_bloc.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(
            fontSize: 40,
            color: Colors.red,
          ),
        ),
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            context.read<ActiveTodoCountBloc>().calculateActiveTodoCount();
          },
          child: Builder(
            builder: (_) {
              final count = context.watch<ActiveTodoCountBloc>().state.count;
              return Text(
                '$count items left',
                style: const TextStyle(
                  fontSize: 18,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
