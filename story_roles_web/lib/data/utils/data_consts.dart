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
  String getAudioProgress(int trackId) =>
      '/api/v1/tracks/$trackId/audio_progress';
  String saveAudioProgress(int trackId) =>
      '/api/v1/tracks/$trackId/audio_progress/save';
  String renameTrack(int trackId) => '/api/v1/tracks/$trackId';
  String deleteTrack(int trackId) => '/api/v1/tracks/$trackId';
  final String getAudioProgresses = '/api/v1/audio_progresses';
  final String getProjects = '/api/v1/projects';
  String projectById(int projectId) => '/api/v1/projects/$projectId';
  String getChapters(int projectId) => '/api/v1/projects/$projectId/chapters';
  String chapterById(int chapterId) => '/api/v1/chapters/$chapterId';
  String generateChapterTracks(int projectId, int chapterId) =>
      '/api/v1/projects/$projectId/chapters/$chapterId/generate';
  String getScript(int trackId) => '/api/v1/tracks/$trackId/script';
  final String getLectorVoices = '/api/v1/lector_voices';
  String lectorVoiceSample(String id) => '/api/v1/lector_voices/$id/sample';
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
