import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<AddTodoEvent>(_addTodo);
    on<EditTodoEvent>(_editTodo);
    on<ToggleTodoEvent>(_toggleTodo);
    on<RemoveTodoEvent>(_removeTodo);
  }

  void _addTodo(AddTodoEvent event, Emitter emit) {
    final newTodo = Todo(desc: event.desc);
    final newTodos = [...state.todos, newTodo];

    emit(state.copyWith(todos: newTodos));
  }

  void _editTodo(EditTodoEvent event, Emitter emit) {
    final newTodos = state.todos
        .map((todo) => todo.id == event.id
            ? Todo(
                desc: event.newDesc,
                id: todo.id,
                completed: todo.completed,
              )
            : todo)
        .toList();

    emit(state.copyWith(todos: newTodos));
  }

  void _toggleTodo(ToggleTodoEvent event, Emitter emit) {
    final newTodos = state.todos
        .map((todo) => todo.id == event.id
            ? Todo(
                desc: todo.desc,
                id: todo.id,
                completed: !todo.completed,
              )
            : todo)
        .toList();

    emit(state.copyWith(todos: newTodos));
  }

  void _removeTodo(RemoveTodoEvent event, Emitter emit) {
    final newTodos = state.todos
        .where(
          (todo) => todo.id != event.id,
        )
        .toList();

    emit(state.copyWith(todos: newTodos));
  }
}
