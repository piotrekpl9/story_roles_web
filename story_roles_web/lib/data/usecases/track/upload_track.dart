import 'dart:typed_data';

import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';

class UploadTrack {
  final TrackRepository repository;

  UploadTrack(this.repository);

  Future<Result> call({
    required String title,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      return await repository.uploadTrack(
        title: title,
        bytes: bytes,
        fileName: fileName,
      );
    } catch (e) {
      return Error(const ServerFailure('Failed to upload track'));
    }
  }
}
