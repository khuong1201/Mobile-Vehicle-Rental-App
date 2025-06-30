FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Cài đặt cơ bản
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app
RUN chown -R flutteruser:flutteruser /sdks/flutter /opt/android-sdk-linux

# Copy keystore và key.properties
COPY android/key.properties android/key.properties
COPY android/your-release-key.jks android/your-release-key.jks

# Tận dụng cache
COPY pubspec.yaml pubspec.lock ./
RUN chown -R flutteruser:flutteruser .

USER flutteruser
RUN git config --global --add safe.directory /sdks/flutter
RUN flutter pub get

COPY --chown=flutteruser:flutteruser . .

# Build APK (đã có signing qua key.properties)
RUN flutter build apk --release

# Final stage
FROM busybox AS final
COPY --from=builder /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk /output/
