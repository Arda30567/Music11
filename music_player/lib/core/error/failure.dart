import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [int? code]) : super(message, code);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, [int? code]) : super(message, code);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, [int? code]) : super(message, code);
}

class AudioFailure extends Failure {
  const AudioFailure(String message, [int? code]) : super(message, code);
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message, [int? code]) : super(message, code);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, [int? code]) : super(message, code);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, [int? code]) : super(message, code);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message, [int? code]) : super(message, code);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message, [int? code]) : super(message, code);
}