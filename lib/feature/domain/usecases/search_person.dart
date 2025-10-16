import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/feature/domain/repositories/person_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/person_entity.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams>
{
  final PersonRepository personRepository;
  SearchPerson({required this.personRepository});

  Future<Either<Failure, List<PersonEntity>>> call(SearchPersonParams parms) async {
    return await personRepository.searchPerson(parms.query);
  }
}

class SearchPersonParams extends Equatable
{
  final String query;
  const SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];

}