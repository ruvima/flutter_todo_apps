part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoListEvent {
  final String todoDesc;
  const AddTodoEvent({
    required this.todoDesc,
  });
  @override
  List<Object> get props => [todoDesc];

  @override
  String toString() => 'AddTodoEvent(todoDesc: $todoDesc)';
}

class EditTodoEvent extends TodoListEvent {
  final String id;
  final String newTodoDesc;
  const EditTodoEvent({
    required this.id,
    required this.newTodoDesc,
  });
  @override
  List<Object> get props => [id, newTodoDesc];

  @override
  String toString() => 'EditTodoEvent(id: $id, newTodoDesc: $newTodoDesc)';
}

class ToggleTodoEvent extends TodoListEvent {
  final String id;
  const ToggleTodoEvent({
    required this.id,
  });
  @override
  List<Object> get props => [id];

  @override
  String toString() => 'ToggleTodoEvent(id: $id)';
}

class RemoveTodoEvent extends TodoListEvent {
  final String id;
  const RemoveTodoEvent({
    required this.id,
  });
  @override
  List<Object> get props => [id];

  @override
  String toString() => 'RemoveTodoEvent(id: $id)';
}
