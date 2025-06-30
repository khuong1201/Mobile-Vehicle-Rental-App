FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Tạo user và thư mục làm việc
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app
RUN chown -R flutteruser:flutteruser /sdks/flutter /opt/android-sdk-linux

# Copy pubspec để tận dụng cache (tách riêng để nếu không đổi thì không cần tải lại package)
COPY pubspec.yaml pubspec.lock ./
RUN chown -R flutteruser:flutteruser .

# Cài dependency
USER flutteruser
RUN git config --global --add safe.directory /sdks/flutter
RUN flutter pub get

# Trở lại quyền root để copy file bảo mật
USER root
COPY ./android/key.properties android/key.properties
COPY ./android/my-release-key.jks android/my-release-key.jks

# ❗ Copy toàn bộ mã nguồn, TRỪ pubspec.* (đã copy trước)
COPY --chown=flutteruser:flutteruser . . 
# Lưu ý: pubspec.* sẽ không bị đè vì nằm trong `.dockerignore`

# Build APK
USER flutteruser
RUN flutter build apk --release

# Final image
FROM busybox AS final
COPY --from=builder /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk /output/
