# Stage 1: Build APK
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Tạo user thường và thiết lập thư mục làm việc
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app

# Cấp quyền cho Flutter và Android SDK
RUN chown -R flutteruser:flutteruser /sdks/flutter /opt/android-sdk-linux

# Chuyển sang user flutteruser
USER flutteruser

# Copy pubspec để tận dụng cache
COPY --chown=flutteruser:flutteruser pubspec.yaml pubspec.lock ./

# Cấu hình Git và tải thư viện
RUN git config --global --add safe.directory /sdks/flutter
RUN flutter pub get

# Copy file keystore
COPY --chown=flutteruser:flutteruser ./android/key.properties android/key.properties
COPY --chown=flutteruser:flutteruser ./android/my-release-key.jks android/my-release-key.jks

# Copy mã nguồn
COPY --chown=flutteruser:flutteruser . .

# Build APK
RUN flutter build apk --release

# Stage 2: Chỉ chứa APK
FROM busybox AS final
COPY --from=builder /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk /output/