import 'package:get_storage/get_storage.dart';
import '../../core/constants.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.authTokenKey, token);
  }

  static Future<String?> getToken() async {
    return _storage.read(AppConstants.authTokenKey);
  }

  static Future<void> clearAll() async {
    await _storage.erase();
  }

  // اريد حفظ نوع المستخدم (باحث عن عمل، صاحب عمل، )
  static const String userTypeKey = 'user_type';

  static Future<void> saveUserType(String userType) async {
    await _storage.write(userTypeKey, userType);
  }
  static Future<String?> getUserType() async {
    return _storage.read(userTypeKey);
  }

}