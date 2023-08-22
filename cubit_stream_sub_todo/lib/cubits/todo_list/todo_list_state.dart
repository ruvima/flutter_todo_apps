// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_list_cubit.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(
      todos: [
        Todo(desc: 'homework', id: '1'),
        Todo(desc: 'running', id: '2'),
        Todo(desc: 'study', id: '3', completed: true),
      ],
    );
  }

  @override
  List<Object> get props => [todos];

  @override
  bool get stringify => true;

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
