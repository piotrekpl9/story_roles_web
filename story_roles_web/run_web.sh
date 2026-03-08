#!/bin/bash
# Dev: uruchamia Flutter web w Chrome z wyłączonymi CORS.
# Nigdy nie używaj w produkcji.
flutter run -d chrome \
  --web-browser-flag="--disable-web-security" \
  --web-browser-flag="--user-data-dir=/tmp/chrome_no_cors"
