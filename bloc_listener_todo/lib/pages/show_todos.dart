import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/filtered_todos/filtered_todos_bloc.dart';
import '../blocs/todo_filter/todo_filter_bloc.dart';
import '../blocs/todo_list/todo_list_bloc.dart';
import '../blocs/todo_search/todo_search_bloc.dart';
import '../models/todo.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            context.read<FilteredTodosBloc>().setFilteredTodos();
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            context.read<FilteredTodosBloc>().setFilteredTodos();
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            context.read<FilteredTodosBloc>().setFilteredTodos();
          },
        ),
      ],
      child: BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
        builder: (context, state) {
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final todo = state.filteredTodos[index];
              return _TodoCard(todo: todo);
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

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return _TodoDismissibleWidget(
      todo: todo,
      child: ListTile(
        leading: _TodoCheckboxWidget(todo: todo),
        title: Text(todo.desc),
        onTap: () => dialog(context),
      ),
    );
  }

  void dialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return _TodoEditDialog(
          todo: todo,
        );
      },
    );
  }
}

class _TodoCheckboxWidget extends StatelessWidget {
  const _TodoCheckboxWidget({
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: todo.completed,
      onChanged: (value) {
        context.read<TodoListBloc>().add(
              ToggleTodoEvent(id: todo.id),
            );
      },
    );
  }
}

class _TodoEditDialog extends StatefulWidget {
  const _TodoEditDialog({
    required this.todo,
  });

  final Todo todo;

  @override
  State<_TodoEditDialog> createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends State<_TodoEditDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.todo.desc;
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              context.read<TodoListBloc>().add(
                    EditTodoEvent(
                        newDesc: _controller.text.trim(), id: widget.todo.id),
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }
}

class _TodoDismissibleWidget extends StatelessWidget {
  const _TodoDismissibleWidget({
    required this.todo,
    required this.child,
  });

  final Todo todo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: const _DismissibleBackground(1),
      secondaryBackground: const _DismissibleBackground(2),
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
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        context.read<TodoListBloc>().add(
              RemoveTodoEvent(id: todo.id),
            );
      },
      key: Key(todo.id),
      child: child,
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  final int direction;
  const _DismissibleBackground(this.direction);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: direction == 1 ? Alignment.centerLeft : Alignment.centerRight,
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
