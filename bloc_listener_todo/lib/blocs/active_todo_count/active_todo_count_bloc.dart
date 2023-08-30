import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../blocs.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  final TodoListBloc _todoListBloc;
  ActiveTodoCountBloc({required TodoListBloc todoListBloc})
      : _todoListBloc = todoListBloc,
        super(const ActiveTodoCountState(count: 0)) {
    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(count: event.count));
    });

    init();
  }

  void calculateActiveTodoCount() {
    final count = _todoListBloc.state.todos
        .where((todo) => !todo.completed)
        .toList()
        .length;

    add(CalculateActiveTodoCountEvent(count: count));
  }

  void init() {
    final initialCount = _todoListBloc.state.todos
        .where((todo) => !todo.completed)
        .toList()
        .length;

    add(CalculateActiveTodoCountEvent(count: initialCount));
  }
}
