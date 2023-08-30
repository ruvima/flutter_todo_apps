import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/active_todo_count/active_todo_count_bloc.dart';
import 'blocs/filtered_todos/filtered_todos_bloc.dart';
import 'blocs/todo_filter/todo_filter_bloc.dart';
import 'blocs/todo_list/todo_list_bloc.dart';
import 'blocs/todo_search/todo_search_bloc.dart';
import 'pages/todos_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        BlocProvider<TodoFilterBloc>(
          create: (context) => TodoFilterBloc(),
        ),
        BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        BlocProvider<ActiveTodoCountBloc>(
          create: (context) => ActiveTodoCountBloc(
            todoListBloc: context.read<TodoListBloc>(),
          ),
        ),
        BlocProvider<FilteredTodosBloc>(
          create: (context) => FilteredTodosBloc(
            todoListBloc: context.read<TodoListBloc>(),
            todoFilterBloc: context.read<TodoFilterBloc>(),
            todoSearchBloc: context.read<TodoSearchBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodosPages(),
      ),
    );
  }
}
