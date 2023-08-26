part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({required this.todos});

  factory TodoListState.initial() => TodoListState(
        todos: [
          Todo(desc: 'Do the grocery shopping', id: '1', completed: false),
          Todo(desc: 'Wash the car', id: '2', completed: true),
          Todo(desc: 'Study for the exam', id: '3', completed: false),
          Todo(desc: 'Exercise', id: '4', completed: false),
        ],
      );

  @override
  List<Object> get props => [todos];

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }

  @override
  bool get stringify => true;
}
