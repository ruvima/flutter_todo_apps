import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_search_event.dart';
part 'todo_search_state.dart';

class TodoSearchBloc extends Bloc<TodoSearchEvent, TodoSearchState> {
  TodoSearchBloc() : super(TodoSearchState.intial()) {
    on<SetSearchTermEvent>(
      (event, emit) {
        emit(state.copyWith(searchTerm: event.newSearchTerm));
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  /// Returns an event transformer that debounces the events with a given duration.
  EventTransformer<SetSearchTermEvent> debounce<SetSearchTermEvent>(
      Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).flatMap((mapper));
    };
  }
}
