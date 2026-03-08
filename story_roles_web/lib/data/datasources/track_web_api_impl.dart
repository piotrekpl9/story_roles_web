import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/data/models/track_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class TrackWebApiImpl implements TrackWebApi {
  final Dio dio;

  TrackWebApiImpl({required this.dio});

  @override
  Future<List<TrackResponseDto>> getAll() async {
    final response = await dio.get(DataConsts.endpoints.getTracks);
    return (response.data["data"]["tracks"] as List?)
            ?.map((e) => TrackResponseDto.fromJson(e))
            .toList() ??
        [];
  }
}
