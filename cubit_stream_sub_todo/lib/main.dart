import 'package:cubit_stream_sub_todo/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/todos_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterCubit>(
          create: (context) => TodoFilterCubit(),
        ),
        BlocProvider<TodoSearchCubit>(
          create: (context) => TodoSearchCubit(),
        ),
        BlocProvider<TodoListCubit>(
          create: (context) => TodoListCubit(),
        ),
        BlocProvider<ActiveTodoCountCubit>(
          create: (context) => ActiveTodoCountCubit(
            initialActiveTodoCount:
                context.read<TodoListCubit>().state.todos.length,
            todoListCubit: BlocProvider.of<TodoListCubit>(context),
          ),
        ),
        BlocProvider<FilteredTodosCubit>(
          create: (context) => FilteredTodosCubit(
            intialTodos: context.read<TodoListCubit>().state.todos,
            todoFilterCubit: context.read<TodoFilterCubit>(),
            todoSearchCubit: context.read<TodoSearchCubit>(),
            todoListCubit: context.read<TodoListCubit>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const TodosPage(),
      ),
    );
  }
}
