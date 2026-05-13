abstract class StorageDataSource {
  Future<void> writeToken(String token);
  Future<String?> readToken();
  Future<void> removeToken();
  Future<void> writeUserData({required String email, String? createdAt, bool isAdmin = false});
  Future<Map<String, String?>> readUserData();
}
