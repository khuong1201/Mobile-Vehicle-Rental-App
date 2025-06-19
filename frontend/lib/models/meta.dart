class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;

  PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
    );
  }
}
