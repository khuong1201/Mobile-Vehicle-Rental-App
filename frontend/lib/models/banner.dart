class BannerApp {
  final String bannerName;
  final String bannerUrl;
  final String bannerId;

  BannerApp({
    required this.bannerName,
    required this.bannerUrl,
    required this.bannerId,
  });

  factory BannerApp.fromJson(Map<String, dynamic> json) {
    return BannerApp(
      bannerName: json['bannerName'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      bannerId: json['bannerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerName': bannerName,
      'bannerUrl': bannerUrl,
      'bannerId': bannerId,
    };
  }
}
