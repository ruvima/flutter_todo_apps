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

  FilteredTodosBloc({
    required TodoListBloc todoListBloc,
    required TodoFilterBloc todoFilterBloc,
    required TodoSearchBloc todoSearchBloc,
  })  : _todoListBloc = todoListBloc,
        _todoFilterBloc = todoFilterBloc,
        _todoSearchBloc = todoSearchBloc,
        super(const FilteredTodosState(filteredTodos: [])) {
    on<SetFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });

    init();
  }

  void init() {
    final initialFilteredTodos = _todoListBloc.state.todos;
    add(SetFilteredTodosEvent(filteredTodos: initialFilteredTodos));
  }

  List<Todo> _filteredTodos(Filter filter, List<Todo> todos) {
    if (filter == Filter.active) {
      return todos.where((todo) => !todo.completed).toList();
    } else if (filter == Filter.completed) {
      return todos.where((todo) => todo.completed).toList();
    } else {
      return todos;
    }
  }

  List<Todo> _searchTodos(String serchTerm, List<Todo> todos) {
    if (todos.isNotEmpty) {
      return todos
          .where(
            (todo) => todo.desc.toLowerCase().contains(
                  serchTerm.toLowerCase(),
                ),
          )
          .toList();
    }
    return todos;
  }

  void setFilteredTodos() {
    final todos = _todoListBloc.state.todos;

    final filterList = _filteredTodos(_todoFilterBloc.state.filter, todos);

    final filteredTodos =
        _searchTodos(_todoSearchBloc.state.search, filterList);

    add(SetFilteredTodosEvent(filteredTodos: filteredTodos));
  }
}
