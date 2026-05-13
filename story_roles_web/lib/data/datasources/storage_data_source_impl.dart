import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';

class StorageDataSourceImpl implements StorageDataSource {
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';
  static const _createdAtKey = 'auth_created_at';
  static const _isAdminKey = 'auth_is_admin';

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
    await prefs.remove(_isAdminKey);
  }

  @override
  Future<void> writeUserData({required String email, String? createdAt, bool isAdmin = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    if (createdAt != null) {
      await prefs.setString(_createdAtKey, createdAt);
    }
    await prefs.setBool(_isAdminKey, isAdmin);
  }

  @override
  Future<Map<String, String?>> readUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_emailKey),
      'created_at': prefs.getString(_createdAtKey),
      'is_admin': prefs.getBool(_isAdminKey)?.toString(),
    };
  }
}
