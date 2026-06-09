import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final _storage = FlutterSecureStorage();

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: "access_token", value: access);
    await _storage.write(key: "refresh_token", value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
