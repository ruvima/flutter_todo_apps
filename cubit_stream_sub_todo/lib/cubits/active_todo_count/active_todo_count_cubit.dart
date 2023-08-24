import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../todo_list/todo_list_cubit.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  late StreamSubscription _todoListSubscription;
  final TodoListCubit _todoListCubit;

  ActiveTodoCountCubit({
    required TodoListCubit todoListCubit,
    required int initialActiveTodoCount,
  })  : _todoListCubit = todoListCubit,
        super(
          ActiveTodoCountState(
            activeTodoCount: initialActiveTodoCount,
          ),
        ) {
    _todoListSubscription = _todoListCubit.stream.listen(
      (TodoListState todoListState) {
        print(todoListState);
        final newActiveCount =
            todoListState.todos.where((e) => !e.completed).toList().length;

        emit(state.copyWith(activeTodoCount: newActiveCount));
      },
    );
  }

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    return super.close();
  }
}
