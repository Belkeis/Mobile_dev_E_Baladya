import '../database/database_helper.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';

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
      result.add({
        'booking': booking,
        'service': service,
      });
    }

    return result;
  }
}

