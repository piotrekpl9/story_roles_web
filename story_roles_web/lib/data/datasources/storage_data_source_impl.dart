import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';

class StorageDataSourceImpl implements StorageDataSource {
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';
  static const _createdAtKey = 'auth_created_at';

  @override
  Future<void> writeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_createdAtKey);
  }

  @override
  Future<void> writeUserData({required String email, String? createdAt}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    if (createdAt != null) {
      await prefs.setString(_createdAtKey, createdAt);
    }
  }

  @override
  Future<Map<String, String?>> readUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_emailKey),
      'created_at': prefs.getString(_createdAtKey),
    };
  }
}
