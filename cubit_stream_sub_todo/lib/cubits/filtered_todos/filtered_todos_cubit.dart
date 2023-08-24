// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';
import '../todo_filter/todo_filter_cubit.dart';
import '../todo_list/todo_list_cubit.dart';
import '../todo_search/todo_search_cubit.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late StreamSubscription _todoFilterSubscription;
  late StreamSubscription _todoSearchSubscription;
  late StreamSubscription _todoListSubscription;

  final TodoFilterCubit _todoFilterCubit;
  final TodoSearchCubit _todoSearchCubit;
  final TodoListCubit _todoListCubit;
  FilteredTodosCubit({
    required List<Todo> intialTodos,
    required TodoFilterCubit todoFilterCubit,
    required TodoSearchCubit todoSearchCubit,
    required TodoListCubit todoListCubit,
  })  : _todoFilterCubit = todoFilterCubit,
        _todoSearchCubit = todoSearchCubit,
        _todoListCubit = todoListCubit,
        super(FilteredTodosState(filteredTodos: intialTodos)) {
    _todoFilterSubscription = todoFilterCubit.stream.listen(
      (TodoFilterState todoFilterState) {
        setFilteredTodos();
      },
    );
    _todoSearchSubscription = todoSearchCubit.stream.listen(
      (TodoSearchState todoSearchState) {
        setFilteredTodos();
      },
    );
    _todoListSubscription = todoListCubit.stream.listen(
      (TodoListState todoListState) {
        setFilteredTodos();
      },
    );
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    switch (_todoFilterCubit.state.filter) {
      case Filter.active:
        filteredTodos = _todoListCubit.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = _todoListCubit.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = _todoListCubit.state.todos;
        break;
    }

    if (filteredTodos.isNotEmpty) {
      filteredTodos = filteredTodos
          .where(
            (Todo todo) => todo.desc.toLowerCase().contains(
                  _todoSearchCubit.state.searchTerm,
                ),
          )
          .toList();
    }

    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    _todoFilterSubscription.cancel();
    _todoSearchSubscription.cancel();
    _todoListSubscription.cancel();
    return super.close();
  }
}
