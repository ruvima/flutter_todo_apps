part of 'active_todo_count_bloc.dart';

class ActiveTodoCountState extends Equatable {
  final int count;
  const ActiveTodoCountState({
    required this.count,
  });

  @override
  List<Object> get props => [count];

  ActiveTodoCountState copyWith({
    int? count,
  }) {
    return ActiveTodoCountState(
      count: count ?? this.count,
    );
  }

  @override
  bool get stringify => true;
}
