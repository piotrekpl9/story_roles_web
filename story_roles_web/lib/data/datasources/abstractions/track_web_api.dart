import 'package:story_roles_web/data/models/track_response_dto.dart';

abstract class TrackWebApi {
  Future<List<TrackResponseDto>> getAll();
}
