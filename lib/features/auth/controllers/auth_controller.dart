import 'package:flutter/foundation.dart';
import '../../../data/models/user_model.dart';
import '../../job_seeker/provider/profile_model.dart';
import '../repositories/auth_repository.dart';

class AuthController with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  UserModel? _user;
  bool _loading = false;
  ProfileModel? profile;
  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String phone, String password) async {
    _loading = true;
    notifyListeners();
    final res = await _repo.login(phone, password);
    _loading = false;
    if (res['ok'] == true) {
      _user = (await _repo.getProfile()) as UserModel?;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> register(Map<String, dynamic> payload) async {
    _loading = true;
    notifyListeners();
    final resp = await _repo.register(payload);
    _loading = false;
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _repo.logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> loadProfile() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await _repo.getProfile();
      if (data != null) {
        final userJson = data['data']['user'];
        final profileJson = data['data']['profile'];

        _user = UserModel.fromJson(userJson);
        profile = ProfileModel.fromJson(profileJson);

        _loading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("خطأ تحميل الملف الشخصي: $e");
    }

    _loading = false;
    notifyListeners();
    return false;
  }
}
