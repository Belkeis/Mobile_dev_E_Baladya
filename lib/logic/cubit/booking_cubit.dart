import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/booking_repository.dart';
import '../../data/models/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;

  BookingCubit(this._bookingRepository) : super(BookingInitial());

  Future<void> loadBookings(int userId) async {
    emit(BookingLoading());
    try {
      final bookingsWithService = await _bookingRepository.getBookingsWithService(userId);
      emit(BookingsLoaded(bookingsWithService));
    } catch (e) {
      emit(BookingError('حدث خطأ أثناء تحميل الحجوزات'));
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    emit(BookingLoading());
    try {
      final bookingId = await _bookingRepository.createBooking(booking);
      final newBooking = booking.copyWith(id: bookingId);
      emit(BookingCreated(newBooking));
      // Reload bookings
      await loadBookings(booking.userId);
    } catch (e) {
      emit(BookingError('حدث خطأ أثناء إنشاء الحجز'));
    }
  }
}


