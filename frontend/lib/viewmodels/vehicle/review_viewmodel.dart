import 'package:flutter/material.dart';
import 'package:frontend/api_services/vehicle/api_report_review.dart';
import 'package:frontend/api_services/vehicle/reviews_api.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/models/meta.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final AuthService authService;

  final List<ReviewModel> _reviews = [];
  PaginationMeta? _meta;
  bool _isLoading = false;
  String? _errorMessage;

  List<ReviewModel> get reviews => _reviews;
  PaginationMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ReviewViewModel(this.authService);

  /// Fetch review by vehicleId
  Future<void> fetchReviews(
    BuildContext context, {
    required String vehicleId,
    int page = 1,
    int limit = 10,
    bool clearBefore = false,
  }) async {
    if (_isLoading) return;
    _isLoading = true;
    if (clearBefore) _reviews.clear();
    notifyListeners();

    final response = await ReviewsApi.getReviews(
      this,
      authService: authService,
      vehicleId: vehicleId,
      page: page,
      limit: limit,
    );

    _isLoading = false;

    if (response.success) {
      _reviews.addAll(response.data ?? []);
      _meta = response.meta;
      _errorMessage = null;
    } else {
      _errorMessage = response.message;
    }
    notifyListeners();
  }

  /// Create a new review
  Future<bool> createReview(
    BuildContext context, {
    required String vehicleId,
    required int rating,
    String? comment,
  }) async {
    final response = await ReviewsApi.createReview(
      this,
      authService: authService,
      vehicleId: vehicleId,
      rating: rating,
      comment: comment ?? '',
    );

    if (response.success) {
      _errorMessage = null;
      print("success");
      await fetchReviews(context, vehicleId: vehicleId, clearBefore: true);
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Delete review
  Future<bool> deleteReview(
    BuildContext context, {
    required String reviewId,
  }) async {
    final response = await ReviewsApi.deleteReview(
      this,
      authService: authService,
      reviewId: reviewId,
    );

    if (response.success) {
      _reviews.removeWhere((r) => r.id == reviewId);
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  /// Report review
  Future<bool> reportReview(
    BuildContext context, {
    required String reviewId,
    required String vehicleId,
    required String reason,
  }) async {
    final response = await ApiReportReview.reportReview(
      this,
      authService: authService,
      reviewId: reviewId,
      vehicleId: vehicleId,
      reason: reason,
    );

    if (response.success) {
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _reviews.clear();
    _meta = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
