import 'package:cubit_listener_todo/cubits/filtered_todo/filtered_todo_cubit.dart';
import 'package:cubit_listener_todo/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:cubit_listener_todo/cubits/todo_search/todo_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/todo_list/todo_list_cubit.dart';
import '../models/todo.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListCubit, TodoListState>(
          listener: (context, state) {
            context.read<FilteredTodoCubit>().setFilteredTodos();
          },
        ),
        BlocListener<TodoFilterCubit, TodoFilterState>(
          listener: (context, state) {
            context.read<FilteredTodoCubit>().setFilteredTodos();
          },
        ),
        BlocListener<TodoSearchCubit, TodoSearchState>(
          listener: (context, state) {
            context.read<FilteredTodoCubit>().setFilteredTodos();
          },
        ),
      ],
      child: BlocBuilder<FilteredTodoCubit, FilteredTodoState>(
        builder: (context, state) {
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final todos = state.filteredTodos[index];
              return Dismissible(
                key: Key(todos.id),
                onDismissed: (direction) {
                  context.read<TodoListCubit>().removeTodo(todos.id);
                },
                confirmDismiss: (_) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('This can\'t be undone'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                background: const _DismissiableBackground(direction: 1),
                secondaryBackground:
                    const _DismissiableBackground(direction: 2),
                child: _TodoItem(
                  todo: todos,
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
            ),
            itemCount: state.filteredTodos.length,
          );
        },
      ),
    );
  }
}

class _DismissiableBackground extends StatelessWidget {
  final int direction;
  const _DismissiableBackground({
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(4),
      alignment: direction == 1 ? Alignment.centerLeft : Alignment.centerRight,
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}

class _TodoItem extends StatefulWidget {
  final Todo todo;
  const _TodoItem({
    required this.todo,
  });

  @override
  State<_TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<_TodoItem> {
  final _editController = TextEditingController();
  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (_) {
          context.read<TodoListCubit>().toggleTodo(widget.todo.id);
        },
      ),
      title: Text(widget.todo.desc),
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            _editController.text = widget.todo.desc;
            return Form(
              child: AlertDialog(
                title: const Text('Edit todo'),
                content: TextFormField(
                  controller: _editController,
                  validator: (String? newDesc) {
                    newDesc ??= '';
                    if (newDesc.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        if (Form.of(context).validate()) {
                          context.read<TodoListCubit>().editTodo(
                                widget.todo.id,
                                _editController.text.trim(),
                              );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Edit'),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
