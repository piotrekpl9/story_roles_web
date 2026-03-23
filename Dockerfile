# Stage 1: Build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.29.2 AS build
WORKDIR /app
COPY story_roles_web/ .
RUN flutter pub get
RUN flutter build web --release --base-href "/"

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY story_roles_web/deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /var/www/story_roles_web
EXPOSE 80
