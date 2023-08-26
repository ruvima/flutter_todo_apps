import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';
import '../blocs.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodoListBloc _todoListBloc;
  final TodoFilterBloc _todoFilterBloc;
  final TodoSearchBloc _todoSearchBloc;

  late StreamSubscription _todoFilterSubscription;
  late StreamSubscription _todoSearchSubscription;
  late StreamSubscription _todoListSubscription;

  FilteredTodosBloc({
    required TodoListBloc todoListBloc,
    required TodoFilterBloc todoFilterBloc,
    required TodoSearchBloc todoSearchBloc,
  })  : _todoListBloc = todoListBloc,
        _todoFilterBloc = todoFilterBloc,
        _todoSearchBloc = todoSearchBloc,
        super(
          const FilteredTodosState(filteredTodos: []),
        ) {
    // Listen for changes in the filter state
    _todoFilterSubscription = _todoFilterBloc.stream.listen(
      (event) {
        _setFilteredTodos();
      },
    );

    // Listen for changes in the search state
    _todoSearchSubscription = _todoSearchBloc.stream.listen(
      (event) {
        _setFilteredTodos();
      },
    );

    // Listen for changes in the todo list state
    _todoListSubscription = _todoListBloc.stream.listen(
      (event) {
        _setFilteredTodos();
      },
    );

    on<SetFilteredTodosEvent>(
      (event, emit) {
        emit(state.copyWith(filteredTodos: event.filteredTodos));
      },
    );
    init();
  }

  /// Initializes the filtered todos with initial data.
  void init() {
    final initialFilteredTodos = _todoListBloc.state.todos;
    add(SetFilteredTodosEvent(filteredTodos: initialFilteredTodos));
  }

  /// Filters the todos based on the selected filter.
  List<Todo> _filterTodos(Filter filter, List<Todo> todos) {
    if (filter == Filter.active) {
      return todos.where((todo) => !todo.completed).toList();
    } else if (filter == Filter.completed) {
      return todos.where((todo) => todo.completed).toList();
    } else {
      return todos;
    }
  }

  /// Searches todos based on the provided search term.
  List<Todo> _searchTodos(String searchTerm, List<Todo> todos) {
    if (todos.isNotEmpty) {
      return todos
          .where(
            (todo) =>
                todo.desc.toLowerCase().contains(searchTerm.toLowerCase()),
          )
          .toList();
    }
    return todos;
  }

  /// Sets the filtered todos based on filter and search term.
  void _setFilteredTodos() {
    final todos = _todoListBloc.state.todos;

    final filtered = _filterTodos(_todoFilterBloc.state.filter, todos);

    final newFilteredTodos =
        _searchTodos(_todoSearchBloc.state.searchTerm, filtered);

    add(SetFilteredTodosEvent(filteredTodos: newFilteredTodos));
  }

  @override
  Future<void> close() {
    _todoFilterSubscription.cancel();
    _todoSearchSubscription.cancel();
    _todoListSubscription.cancel();
    return super.close();
  }
}
