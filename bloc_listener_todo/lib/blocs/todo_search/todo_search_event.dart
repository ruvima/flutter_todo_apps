part of 'todo_search_bloc.dart';

sealed class TodoSearchEvent extends Equatable {
  const TodoSearchEvent();

  @override
  List<Object> get props => [];
}

class SetSearchEvent extends TodoSearchEvent {
  final String searchTerm;
  const SetSearchEvent({
    required this.searchTerm,
  });

  @override
  List<Object> get props => [searchTerm];
}
