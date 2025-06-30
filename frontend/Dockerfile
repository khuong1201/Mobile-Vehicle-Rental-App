FROM ghcr.io/cirruslabs/flutter:stable AS builder

ENV PUB_HOSTED_URL=https://pub.dev
ENV FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com

# Tạo user thường
RUN useradd -ms /bin/bash flutteruser

# Làm việc dưới quyền root trước
WORKDIR /home/flutteruser/app

# Fix permission cho Android SDK (đây là điểm quan trọng)
RUN chown -R flutteruser:flutteruser /sdks/flutter /opt/android-sdk-linux

# Copy pubspec trước để tận dụng cache & cấp quyền
COPY pubspec.yaml pubspec.lock ./
RUN chown -R flutteruser:flutteruser .

# Chuyển sang user thường
USER flutteruser

# Đảm bảo Flutter SDK an toàn để git không cảnh báo
RUN git config --global --add safe.directory /sdks/flutter

# Cài thư viện
RUN flutter pub get

# Copy toàn bộ mã nguồn
COPY --chown=flutteruser:flutteruser . .

# Build APK
RUN flutter build apk --release

# ----- Stage 2: Image nhẹ chỉ chứa APK -----
FROM busybox AS final
COPY --from=builder /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk /output/
