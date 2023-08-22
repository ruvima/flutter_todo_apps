import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cubit_stream_sub_todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:equatable/equatable.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  late StreamSubscription _todoListSubscription;
  final TodoListCubit _todoListCubit;
  final int initialActiveTodoCount;

  ActiveTodoCountCubit(
      {required todoListCubit, required this.initialActiveTodoCount})
      : _todoListCubit = todoListCubit,
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
