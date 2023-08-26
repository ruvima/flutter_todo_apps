import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../blocs.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  late StreamSubscription _todoListSubscription;

  final TodoListBloc _todoListBloc;

  ActiveTodoCountBloc({required TodoListBloc todoListBloc})
      : _todoListBloc = todoListBloc,
        super(
          const ActiveTodoCountState(activeTodoCount: 0),
        ) {
    _todoListSubscription = _todoListBloc.stream.listen(
      (todoListState) {
        print(todoListState);
        final currentActiveTodoCount = _todoListBloc.state.todos
            .where((todo) => !todo.completed)
            .toList()
            .length;

        add(CalculateActiveTodoCountEvent(
            activeTodoCount: currentActiveTodoCount));
      },
    );

    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
    init();
  }

  void init() {
    final intialActiveTodoCount = _todoListBloc.state.todos
        .where((todo) => !todo.completed)
        .toList()
        .length;

    add(
      CalculateActiveTodoCountEvent(activeTodoCount: intialActiveTodoCount),
    );
  }

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    return super.close();
  }
}
