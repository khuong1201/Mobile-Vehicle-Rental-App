import 'package:frontend/models/meta.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final PaginationMeta? meta;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.meta,
  });
}
