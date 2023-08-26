// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filtered_todos_bloc.dart';

sealed class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class SetFilteredTodosEvent extends FilteredTodosEvent {
  final List<Todo> filteredTodos;
  const SetFilteredTodosEvent({
    required this.filteredTodos,
  });

  @override
  List<Object> get props => [filteredTodos];

  @override
  String toString() => 'SetFilteredTodosEvent(filteredTodos: $filteredTodos)';
}
