
import 'package:flutter/foundation.dart';
import '../../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  UserModel? _user;
  bool _loading = false;

  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    final res = await _repo.login(username, password);
    _loading = false;
    if (res['ok'] == true) {
      // try to load profile
      _user = await _repo.getProfile();
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

  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();
    _user = await _repo.getProfile();
    _loading = false;
    notifyListeners();
  }
}
