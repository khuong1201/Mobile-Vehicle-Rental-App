FROM cirrusci/flutter:3.22.1

WORKDIR /app

COPY pubspec.* ./

RUN flutter pub get
COPY . .

RUN flutter build apk --release


RUN mkdir -p /output && cp build/app/outputs/flutter-apk/app-release.apk /output/