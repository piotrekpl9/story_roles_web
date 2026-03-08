import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_upload_web_api.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class TrackUploadWebApiImpl implements TrackUploadWebApi {
  final Dio dio;

  TrackUploadWebApiImpl({required this.dio});

  @override
  Future<void> upload({
    required String title,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('title', title));
    formData.files.add(
      MapEntry('file', MultipartFile.fromBytes(bytes, filename: fileName)),
    );

    try {
      final response = await dio.post(
        DataConsts.endpoints.uploadTrack,
        data: formData,
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode != 200) {
        final errorMessage =
            response.data['status']?['message'] ?? 'Upload failed';
        throw ValidationFailure(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}
