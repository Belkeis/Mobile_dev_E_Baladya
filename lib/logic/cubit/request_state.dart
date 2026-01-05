part of 'request_cubit.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object?> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<Map<String, dynamic>> requestsWithService;

  const RequestsLoaded(this.requestsWithService);

  @override
  List<Object?> get props => [requestsWithService];
}

class RequestCreated extends RequestState {
  final RequestModel request;

  const RequestCreated(this.request);

  @override
  List<Object?> get props => [request];
}

class RequestError extends RequestState {
  final String message;

  const RequestError(this.message);

  @override
  List<Object?> get props => [message];
}

