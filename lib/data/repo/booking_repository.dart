import '../database/database_helper.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createBooking(BookingModel booking) async {
    return await _dbHelper.insertBooking(booking);
  }

  Future<List<BookingModel>> getBookingsByUserId(int userId) async {
    return await _dbHelper.getBookingsByUserId(userId);
  }

  Future<List<Map<String, dynamic>>> getBookingsWithService(int userId) async {
    final bookings = await getBookingsByUserId(userId);
    final result = <Map<String, dynamic>>[];

    for (final booking in bookings) {
      final service = await _dbHelper.getServiceById(booking.serviceId);
      final bookingType = booking.bookingTypeId != null
          ? await _dbHelper.getBookingTypeById(booking.bookingTypeId!)
          : null;

      result.add({
        'booking': booking,
        'service': service,
        'booking_type': bookingType, // NEW: Include booking type
      });
    }

    return result;
  }
}
