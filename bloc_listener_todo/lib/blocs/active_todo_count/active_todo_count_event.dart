part of 'active_todo_count_bloc.dart';

sealed class ActiveTodoCountEvent extends Equatable {
  const ActiveTodoCountEvent();

  @override
  List<Object> get props => [];
}

class CalculateActiveTodoCountEvent extends ActiveTodoCountEvent {
  final int count;
  const CalculateActiveTodoCountEvent({
    required this.count,
  });
  @override
  List<Object> get props => [count];
}
