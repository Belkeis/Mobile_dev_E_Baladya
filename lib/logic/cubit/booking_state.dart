part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<Map<String, dynamic>> bookingsWithService;

  const BookingsLoaded(this.bookingsWithService);

  @override
  List<Object?> get props => [bookingsWithService];
}

class BookingCreated extends BookingState {
  final BookingModel booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

