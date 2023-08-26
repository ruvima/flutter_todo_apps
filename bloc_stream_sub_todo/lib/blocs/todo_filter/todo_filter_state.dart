part of 'todo_filter_bloc.dart';

enum Filter {
  all,
  active,
  completed,
}

class TodoFilterState extends Equatable {
  final Filter filter;
  const TodoFilterState({
    required this.filter,
  });

  factory TodoFilterState.initial() =>
      const TodoFilterState(filter: Filter.all);

  @override
  List<Object> get props => [filter];

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }

  @override
  bool get stringify => true;
}
