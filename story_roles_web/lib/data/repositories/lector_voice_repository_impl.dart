import 'dart:typed_data';

import 'package:story_roles_web/data/datasources/abstractions/lector_voice_web_api.dart';
import 'package:story_roles_web/domain/entities/lector_voice.dart';
import 'package:story_roles_web/domain/repositories/lector_voice_repository.dart';

class LectorVoiceRepositoryImpl implements LectorVoiceRepository {
  final LectorVoiceWebApi webApi;

  LectorVoiceRepositoryImpl({required this.webApi});

  @override
  Future<List<LectorVoice>> getAll() async {
    final dtos = await webApi.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Uint8List> getSample(String id) => webApi.getSample(id);
}
