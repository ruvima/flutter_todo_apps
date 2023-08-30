import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_search_event.dart';
part 'todo_search_state.dart';

class TodoSearchBloc extends Bloc<TodoSearchEvent, TodoSearchState> {
  TodoSearchBloc() : super(TodoSearchState.initial()) {
    on<SetSearchEvent>(
      (event, emit) {
        emit(state.copyWith(search: event.searchTerm));
      },
      transformer: debounce(const Duration(milliseconds: 1000)),
    );
  }

  EventTransformer<SetSearchEvent> debounce<SetSearchEvent>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).flatMap(mapper);
    };
  }
}
