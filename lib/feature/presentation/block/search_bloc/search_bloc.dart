import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_person.dart';
import 'package:rick_and_morty/feature/presentation/block/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/block/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  // Логика обработки событий теперь описывается в конструкторе
  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    // Регистрируем обработчик для события SearchPersons
    on<SearchPersons>((event, emit) async {
      // emit - это функция для отправки новых состояний (аналог yield)
      emit(PersonSearchLoading());

      final failureOrPerson =
      await searchPerson(SearchPersonParams(query: event.personQuery));

      failureOrPerson.fold(
            (failure) => emit(PersonSearchError(message: _mapFailureToMessage(failure))),
            (person) => emit(PersonSearchLoaded(persons: person)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
