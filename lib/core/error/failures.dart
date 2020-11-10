import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;
  Failure({this.properties  = const []});
  @override
  List<Object> get props => properties;
}

///General Failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}