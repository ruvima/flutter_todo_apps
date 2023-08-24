import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = state.todos.map(
      (todo) {
        if (todo.id == id) {
          return Todo(
            desc: todoDesc,
            id: id,
            completed: todo.completed,
          );
        }
        return todo;
      },
    ).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void toggleTodo(String id) {
    final newTodos = state.todos.map(
      (todo) {
        if (todo.id == id) {
          return Todo(desc: todo.desc, id: id, completed: !todo.completed);
        }
        return todo;
      },
    ).toList();

    emit(state.copyWith(todos: newTodos));
  }

  void removeTodo(String id) {
    final newTodos = state.todos.where((e) => e.id != id).toList();

    emit(state.copyWith(todos: newTodos));
  }
}
