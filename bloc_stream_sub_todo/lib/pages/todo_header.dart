import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(fontSize: 40, color: Colors.red),
        ),
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final activeTodoCount = state.todos
                .where(
                  (todo) => !todo.completed,
                )
                .toList()
                .length;
            context.read<ActiveTodoCountBloc>().add(
                  CalculateActiveTodoCountEvent(
                      activeTodoCount: activeTodoCount),
                );
          },
          child: Builder(builder: (context) {
            final count =
                context.watch<ActiveTodoCountBloc>().state.activeTodoCount;
            return Text(
              '$count items left',
              style: const TextStyle(fontSize: 18),
            );
          }),
        ),
      ],
    );
  }
}
