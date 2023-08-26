import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/todo.dart';
import '../utils/custom_dialog.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final todo = state.filteredTodos[index];
            return _TodoItem(todo: todo);
          },
          separatorBuilder: (_, __) => const Divider(
            color: Colors.grey,
          ),
          itemCount: state.filteredTodos.length,
        );
      },
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      onDismissed: (_) {
        context.read<TodoListBloc>().add(RemoveTodoEvent(id: todo.id));
      },
      background: const _BackgroundColor(direction: 1),
      secondaryBackground: const _BackgroundColor(direction: 2),
      confirmDismiss: (_) {
        return CustomDialog.show(
          context: context,
          title: 'Are you sure?',
          content: const Text('This can\'t be undone'),
          negativeAction: () {
            Navigator.pop(context, false);
          },
          positiveText: 'Delete',
          positiveAction: () {
            Navigator.pop(context, true);
          },
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) {
            context.read<TodoListBloc>().add(ToggleTodoEvent(id: todo.id));
          },
        ),
        title: Text(todo.desc),
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return _EditTodo(todo: todo);
            },
          );
        },
      ),
    );
  }
}

class _BackgroundColor extends StatelessWidget {
  final int direction;
  const _BackgroundColor({
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: direction == 1 ? Alignment.centerLeft : Alignment.centerRight,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class _EditTodo extends StatefulWidget {
  final Todo todo;
  const _EditTodo({
    required this.todo,
  });

  @override
  State<_EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<_EditTodo> {
  final _editTodoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _editTodoController.text = widget.todo.desc;
    return Form(
      child: AlertDialog(
        title: const Text('Edit todo'),
        content: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _editTodoController,
          validator: (desc) {
            desc ??= '';
            if (desc.isEmpty) {
              return 'This field can\'t be empty';
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
                  context.read<TodoListBloc>().add(
                        EditTodoEvent(
                          id: widget.todo.id,
                          newTodoDesc: _editTodoController.text.trim(),
                        ),
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
  }
}
