import 'package:bloc/bloc.dart';
import 'package:cubit_listener_todo/cubits/todo_list/todo_list_cubit.dart';
import 'package:equatable/equatable.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  // Dependency to access all todos
  final TodoListCubit _todoListCubit;

  // Constructor injects todo list cubit
  ActiveTodoCountCubit({required TodoListCubit todoListCubit})
      : _todoListCubit = todoListCubit,
        super(
          const ActiveTodoCountState(count: 0),
        ) {
    // Initialize on startup
    init();
  }
  // Initializes state with number of active todos
  void init() {
    // Get active todos (not completed)
    final initialCount =
        _todoListCubit.state.todos.where((todo) => !todo.completed).length;

    // Update state
    emit(state.copyWith(count: initialCount));
  }

  // Re-calculates and updates active todo count
  void calculateActiveTodoCount(int newCount) {
    // Simply update state with new count
    emit(state.copyWith(count: newCount));
  }
}
