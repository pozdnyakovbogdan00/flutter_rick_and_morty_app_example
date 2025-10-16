import 'package:dartz/dartz.dart';
import 'package:rick_and_morty/core/error/failure.dart';

abstract class UseCase<Type, Parms>{
  Future<Either<Failure, Type>> call(Parms parms);
}