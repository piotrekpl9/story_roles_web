import 'dart:typed_data';

import 'package:story_roles_web/domain/entities/lector_voice.dart';

abstract class LectorVoiceRepository {
  Future<List<LectorVoice>> getAll();
  Future<Uint8List> getSample(String id);
}
