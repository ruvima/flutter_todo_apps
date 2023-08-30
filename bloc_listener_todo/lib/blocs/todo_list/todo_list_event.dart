// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoListEvent {
  final String desc;
  const AddTodoEvent({
    required this.desc,
  });

  @override
  List<Object> get props => [desc];
}

class EditTodoEvent extends TodoListEvent {
  final String newDesc;
  final String id;
  const EditTodoEvent({
    required this.newDesc,
    required this.id,
  });

  @override
  List<Object> get props => [newDesc, id];
}

class ToggleTodoEvent extends TodoListEvent {
  final String id;
  const ToggleTodoEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class RemoveTodoEvent extends TodoListEvent {
  final String id;
  const RemoveTodoEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
