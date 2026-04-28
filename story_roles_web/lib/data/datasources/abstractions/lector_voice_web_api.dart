import 'dart:typed_data';

import 'package:story_roles_web/data/models/lector_voice_response_dto.dart';

abstract class LectorVoiceWebApi {
  Future<List<LectorVoiceResponseDto>> getAll();
  Future<Uint8List> getSample(String id);
}
