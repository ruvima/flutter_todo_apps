part of 'todo_search_bloc.dart';

class TodoSearchState extends Equatable {
  final String search;
  const TodoSearchState({
    required this.search,
  });
  factory TodoSearchState.initial() => const TodoSearchState(search: '');
  @override
  List<Object> get props => [search];

  TodoSearchState copyWith({
    String? search,
  }) {
    return TodoSearchState(
      search: search ?? this.search,
    );
  }

  @override
  bool get stringify => true;
}
