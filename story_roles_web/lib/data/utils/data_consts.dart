class DataConsts {
  static final endpoints = _Endpoints();
  static final apiParameters = _ApiParameters();
  static final dataKeys = _DataKeys();
}

class _Endpoints {
  final String login = "login";
  final String register = "signup";
  final String getProfile = "/api/v1/users/me";
  final String getTracks = "/api/v1/tracks";
  final String uploadTrack = "/api/v1/uploads/create_async";
  String saveAudioProgress(int trackId) =>
      '/api/v1/tracks/$trackId/audio_progress/save';
}

class _ApiParameters {
  final String bearer = "Bearer";
  final String authorization = "Authorization";
  final String email = "email";
  final String user = "user";
  final String password = "password";
}

class _DataKeys {
  final String token = "token";
  final String data = "data";
}
