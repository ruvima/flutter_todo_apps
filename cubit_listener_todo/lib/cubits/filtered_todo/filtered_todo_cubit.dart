import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';
import '../todo_filter/todo_filter_cubit.dart';
import '../todo_list/todo_list_cubit.dart';
import '../todo_search/todo_search_cubit.dart';

part 'filtered_todo_state.dart';

class FilteredTodoCubit extends Cubit<FilteredTodoState> {
  // Dependencies to filter and search todos
  final TodoFilterCubit _todoFilterCubit;
  final TodoSearchCubit _todoSearchCubit;
  final TodoListCubit _todoListCubit;

  // Constructor inject dependencies
  FilteredTodoCubit(
      {required TodoFilterCubit todoFilterCubit,
      required TodoSearchCubit todoSearchCubit,
      required TodoListCubit todoListCubit})
      : _todoFilterCubit = todoFilterCubit,
        _todoSearchCubit = todoSearchCubit,
        _todoListCubit = todoListCubit,
        super(
          const FilteredTodoState(filteredTodos: []),
        ) {
    // Initialize on startup
    init();
  }

  // Initialize filteredTodos with all todos on startup
  void init() {
    emit(state.copyWith(filteredTodos: _todoListCubit.state.todos));
  }
  // Filter todos based on given filter

  List<Todo> _filterTodos(List<Todo> todos, Filter filter) {
    if (filter == Filter.active) {
      return todos.where((t) => !t.completed).toList();
    } else if (filter == Filter.completed) {
      return todos.where((t) => t.completed).toList();
    } else {
      return todos;
    }
  }

  // Search filtered todos for given search term
  List<Todo> _searchTodos(List<Todo> todos, String searchTerm) {
    if (todos.isNotEmpty) {
      todos = todos
          .where(
            (Todo todo) => todo.desc.toLowerCase().contains(searchTerm),
          )
          .toList();

      return todos;
    }
    return todos;
  }

  // Orchestrate filtering and searching
  void setFilteredTodos() {
    // Get latest todos
    final todos = _todoListCubit.state.todos;

    // Filter todos
    final filtered = _filterTodos(todos, _todoFilterCubit.state.filter);

    // Search filtered todos
    final results = _searchTodos(filtered, _todoSearchCubit.state.searchTerm);

    // Update state
    emit(state.copyWith(filteredTodos: results));
  }
}
