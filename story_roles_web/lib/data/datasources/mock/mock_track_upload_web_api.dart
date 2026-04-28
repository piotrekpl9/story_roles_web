import 'dart:typed_data';

import 'package:story_roles_web/data/datasources/abstractions/track_upload_web_api.dart';

class MockTrackUploadWebApi implements TrackUploadWebApi {
  @override
  Future<void> upload({
    required String title,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock always succeeds – no actual upload performed.
  }
}
