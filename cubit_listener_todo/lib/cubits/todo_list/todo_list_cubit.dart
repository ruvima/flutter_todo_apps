import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  void addTodo(String desc) {
    final newTodo = Todo(desc: desc);
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
  }

  void editTodo(String id, String newDesc) {
    final newTodos = state.todos
        .map((Todo todo) => todo.id == id
            ? Todo(
                desc: newDesc,
                id: id,
                completed: todo.completed,
              )
            : todo)
        .toList();

    emit(state.copyWith(todos: newTodos));
  }

  void toggleTodo(String id) {
    final newTodos = state.todos
        .map((Todo todo) => todo.id == id
            ? Todo(
                desc: todo.desc,
                id: id,
                completed: !todo.completed,
              )
            : todo)
        .toList();

    emit(state.copyWith(todos: newTodos));
  }

  void removeTodo(String id) {
    final newTodos = state.todos
        .where(
          (Todo todo) => todo.id != id,
        )
        .toList();

    emit(state.copyWith(todos: newTodos));
  }
}
