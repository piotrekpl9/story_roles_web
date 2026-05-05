FROM dart:3.9 AS build

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/flutter/flutter.git /flutter -b stable
ENV PATH="/flutter/bin:$PATH"
RUN flutter precache --web
ENV FLUTTER_ROOT=/flutter

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
