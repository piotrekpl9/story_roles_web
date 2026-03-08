import 'dart:typed_data';

abstract class TrackUploadWebApi {
  Future<void> upload({
    required String title,
    required Uint8List bytes,
    required String fileName,
  });
}
