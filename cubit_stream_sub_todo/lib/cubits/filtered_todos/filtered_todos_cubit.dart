// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cubit_stream_sub_todo/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:cubit_stream_sub_todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:cubit_stream_sub_todo/cubits/todo_search/todo_search_cubit.dart';
import 'package:cubit_stream_sub_todo/models/todo.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;

  final List<Todo> intialTodos;

  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;
  FilteredTodosCubit({
    required this.intialTodos,
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
  }) : super(FilteredTodosState(filteredTodos: intialTodos)) {
    todoFilterSubscription = todoFilterCubit.stream.listen(
      (TodoFilterState todoFilterState) {
        setFilteredTodos();
      },
    );
    todoSearchSubscription = todoSearchCubit.stream.listen(
      (TodoSearchState todoSearchState) {
        setFilteredTodos();
      },
    );
    todoListSubscription = todoListCubit.stream.listen(
      (TodoListState todoListState) {
        setFilteredTodos();
      },
    );
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListCubit.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListCubit.state.todos;
        break;
    }

    if (filteredTodos.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (Todo todo) => todo.desc.toLowerCase().contains(
                  todoSearchCubit.state.searchTerm,
                ),
          )
          .toList();
    }

    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
