import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';
import '../models/todo.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosCubit>().state.filteredTodos;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Dismissible(
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          key: Key(todos[index].id),
          onDismissed: (_) {
            context.read<TodoListCubit>().removeTodo(todos[index].id);
          },
          confirmDismiss: (_) {
            return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you really want to delete?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
          child: TodoItem(
            todo: todos[index],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        color: Colors.grey,
      ),
      itemCount: todos.length,
    );
  }

  Widget showBackground(int direction) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
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
          context: context,
          builder: (context) {
            textController.text = widget.todo.desc;
            return Form(
              child: AlertDialog(
                title: const Text('Edit todo'),
                content: TextFormField(
                  controller: textController,
                  autofocus: true,
                  validator: (_) {
                    if (textController.text.isEmpty) {
                      return 'Value cannot be empty';
                    }
                    return null;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        if (Form.of(context).validate()) {
                          context
                              .read<TodoListCubit>()
                              .editTodo(widget.todo.id, textController.text);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('EDIT'),
                    );
                  }),
                ],
              ),
            );

            // bool error = false;
            // return StatefulBuilder(
            //   builder: (BuildContext context, StateSetter setState) {
            //     return AlertDialog(
            //       title: const Text('Edit todo'),
            //       content: TextField(
            //         controller: textController,
            //         autofocus: true,
            //         decoration: InputDecoration(
            //             errorText: error ? 'Value cannot be empty' : null),
            //       ),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.pop(context);
            //           },
            //           child: const Text('CANCEL'),
            //         ),
            //         TextButton(
            //           onPressed: () {
            //             error = textController.text.isEmpty ? true : false;
            //             if (!error) {
            //               context
            //                   .read<TodoListCubit>()
            //                   .editTodo(widget.todo.id, textController.text);
            //               Navigator.pop(context);
            //             }
            //           },
            //           child: const Text('EDIT'),
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
        );
      },
    );
  }
}
