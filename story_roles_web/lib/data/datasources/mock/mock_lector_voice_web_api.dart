import 'package:flutter/services.dart';
import 'package:story_roles_web/data/datasources/abstractions/lector_voice_web_api.dart';
import 'package:story_roles_web/data/models/lector_voice_response_dto.dart';

class MockLectorVoiceWebApi implements LectorVoiceWebApi {
  static const _voices = ['tara', 'leah', 'jess', 'leo', 'dan', 'mia', 'zac', 'zoe'];

  @override
  Future<List<LectorVoiceResponseDto>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _voices
        .map((v) => LectorVoiceResponseDto(id: v, name: v, description: ''))
        .toList();
  }

  @override
  Future<Uint8List> getSample(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final data = await rootBundle.load('assets/audio/mock_sample.wav');
    return data.buffer.asUint8List();
  }
}
