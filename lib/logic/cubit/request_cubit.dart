import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/request_repository.dart';
import '../../data/models/request_model.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  final RequestRepository _requestRepository;

  RequestCubit(this._requestRepository) : super(RequestInitial());

  Future<void> loadRequests(int userId) async {
    emit(RequestLoading());
    try {
      final requestsWithService = await _requestRepository.getRequestsWithService(userId);
      emit(RequestsLoaded(requestsWithService));
    } catch (e) {
      emit(RequestError('حدث خطأ أثناء تحميل الطلبات'));
    }
  }

  Future<void> createRequest(RequestModel request) async {
    emit(RequestLoading());
    try {
      final requestId = await _requestRepository.createRequest(request);
      final newRequest = request.copyWith(id: requestId);
      emit(RequestCreated(newRequest));
      // Reload requests
      await loadRequests(request.userId);
    } catch (e) {
      emit(RequestError('حدث خطأ أثناء إنشاء الطلب'));
    }
  }

  Future<void> updateRequestStatus(int requestId, String status) async {
    try {
      final request = await _requestRepository.getRequestById(requestId);
      if (request != null) {
        final updatedRequest = request.copyWith(status: status);
        await _requestRepository.updateRequest(updatedRequest);
        await loadRequests(request.userId);
      }
    } catch (e) {
      emit(RequestError('حدث خطأ أثناء تحديث حالة الطلب'));
    }
  }
}

