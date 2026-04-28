import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/lector_voice_web_api.dart';
import 'package:story_roles_web/data/models/lector_voice_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class LectorVoiceWebApiImpl implements LectorVoiceWebApi {
  final Dio dio;

  LectorVoiceWebApiImpl({required this.dio});

  @override
  Future<List<LectorVoiceResponseDto>> getAll() async {
    final response = await dio.get(DataConsts.endpoints.getLectorVoices);
    final list = response.data['data']['lector_voices'] as List? ?? [];
    return list.map((e) => LectorVoiceResponseDto.fromJson(e)).toList();
  }

  @override
  Future<Uint8List> getSample(String id) async {
    final response = await dio.get<List<int>>(
      DataConsts.endpoints.lectorVoiceSample(id),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
