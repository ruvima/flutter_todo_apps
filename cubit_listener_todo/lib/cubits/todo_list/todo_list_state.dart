part of 'todo_list_cubit.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(desc: 'Do the grocery shopping', id: '1'),
      Todo(desc: 'Study for the exam', id: '2'),
      Todo(desc: 'Exercise', id: '3'),
      Todo(desc: 'Wash the car', completed: true, id: '4'),
    ]);
  }

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
