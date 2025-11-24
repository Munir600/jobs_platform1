
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage =  FlutterSecureStorage();
  static const String tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  // اريد حفظ نوع المستخدم (باحث عن عمل، صاحب عمل، )
  static const String userTypeKey = 'user_type';

  static Future<void> saveUserType(String userType) async {
    await _storage.write(key: userTypeKey, value: userType);
  }
  static Future<String?> getUserType() async {
    return await _storage.read(key: userTypeKey);
  }

}