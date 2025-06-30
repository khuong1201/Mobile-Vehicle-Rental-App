FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Tạo user thường và thư mục làm việc
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app
RUN chown -R flutteruser:flutteruser /sdks/flutter /opt/android-sdk-linux

# Copy pubspec để tận dụng cache
COPY pubspec.yaml pubspec.lock ./
RUN chown -R flutteruser:flutteruser .  # Đảm bảo quyền

# Chạy pub get dưới quyền user thường
USER flutteruser
RUN git config --global --add safe.directory /sdks/flutter
RUN flutter pub get

# Quay lại quyền root để copy file keystore (có thể cần quyền)
USER root

# Copy keystore và key.properties
COPY ./android/key.properties android/key.properties
COPY ./android/my-release-key.jks android/my-release-key.jks

# Copy toàn bộ mã nguồn trừ pubspec.* (đã copy trước rồi)
COPY --chown=flutteruser:flutteruser . .

# Trở lại user thường để build
USER flutteruser
RUN flutter build apk --release

# Final stage - chỉ chứa APK
FROM busybox AS final
COPY --from=builder /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk /output/
