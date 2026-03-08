import 'dart:typed_data';

import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/track.dart';

abstract class TrackRepository {
  Future<List<Track>> getAll({bool forceRefresh = false});
  Future<Result> uploadTrack({
    required String title,
    required Uint8List bytes,
    required String fileName,
  });
}
