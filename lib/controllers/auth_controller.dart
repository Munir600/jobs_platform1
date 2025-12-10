// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../data/models/user_models.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();
  final GetStorage _storage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);

  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final dateOfBirth = ''.obs;
  final profilePicture = ''.obs;
  final bio = ''.obs;
  final location = ''.obs;
  final userType = ''.obs;
  final isVerified = false.obs;
  final createdAt = ''.obs;
  User? get currentUser => _currentUser.value;
  bool get isJobSeeker => _currentUser.value?.userType == 'job_seeker';
  bool get isEmployer => _currentUser.value?.userType == 'employer';

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<bool> login(String phone, String password) async {
    try {
      isLoading.value = true;
      final userLogin = UserLogin(phone: phone, password: password);
      print("JSON SENT TO API: ${userLogin.toJson()}");
      final response = await _apiService.post(
          ApiEndpoints.login,
          userLogin.toJson()
      );
      print("RESPONSE FROM API: $response");
      print("The USERTYPE  FROM API: ${response["data"]["user"]["user_type"]}");
      _currentUser.value = User.fromJson(response["data"]["user"]
      );
     // _storage.write('user_data', response["data"]["user"]);
      final token = response["data"]["token"];
      final ms=response["data"]["message"];
     // print('MESSAGES login  FROM API is : $ms');
      _apiService.setAuthToken(token);
      print('TOKEN SET IN API SERVICE: $token');
      isLoggedIn.value = true;

      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('$ms');
      return true;
    } catch (e) {
      isLoading.value = false;
      AppErrorHandler.showErrorSnack('$e');
      return false;
    }
  }

  Future<bool> register(UserRegistration registration) async {
    try {
      isLoading.value = true;
   //   print('DATA SENT TO API: ${registration.toJson()}');
      final response = await _apiService.post(
        ApiEndpoints.register,
        registration.toJson(),
      );
      print('RESPONSE FROM API: $response');
      _currentUser.value = User.fromJson(response['data']['user']
      );
      _storage.write('user_data', response['data']['user']);
      final token = response['data']['token'];
      final ms=response["data"]["message"];
      _apiService.setAuthToken(token);
      isLoggedIn.value = true;

      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('$ms');
      return true;
    } catch (e) {
      isLoading.value = false;
      AppErrorHandler.showErrorSnack('$e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout, {});
        AppErrorHandler.showSuccessSnack('تم تسجيل الخروج بنجاح');
    } catch (e) {
      AppErrorHandler.showErrorSnack('$e');
    } finally {
      _currentUser.value = null;
      isLoggedIn.value = false;
      _storage.remove('user_data');
      _apiService.removeAuthToken();
      //_storage.remove(AppConstants.authTokenKey);
      Get.offAllNamed('/login');
    }
  }
  void _loadUserFromStorage() {
    final stored = _storage.read('user_data');
    final token = _storage.read(AppConstants.authTokenKey);

    if (stored != null && token != null) {
      isLoggedIn.value = true;
      _apiService.setAuthToken(token);
      
      final user = User.fromJson(stored);
      _currentUser.value = user;

      firstName.value = user.firstName;
      lastName.value = user.lastName;
      email.value = user.email;
      phone.value = user.phone;
      dateOfBirth.value = user.dateOfBirth ?? '';
      profilePicture.value = user.profilePicture ?? '';
      bio.value = user.bio ?? '';
      location.value = user.location ?? '';
      userType.value = user.userType;
      isVerified.value = user.isVerified;
      createdAt.value = user.createdAt.toIso8601String();
    }
  }

  Future<bool> updateProfile(UserProfileUpdate profile) async {
    try {
      isLoading.value = true;

      final data = profile.toJson();
      final response = await _apiService.put(ApiEndpoints.updateProfile, data);

      final updatedUser = User.fromJson(response['data']['user']);
      _currentUser.value = updatedUser;

      _storage.write('user_data', response['data']['user']);
      firstName.value = updatedUser.firstName;
      lastName.value = updatedUser.lastName;
      email.value = updatedUser.email;
      phone.value = updatedUser.phone;
      dateOfBirth.value = updatedUser.dateOfBirth ?? '';
      profilePicture.value = updatedUser.profilePicture ?? '';
      bio.value = updatedUser.bio ?? '';
      location.value = updatedUser.location ?? '';
      userType.value = updatedUser.userType;
      isVerified.value = updatedUser.isVerified;
      createdAt.value = updatedUser.createdAt.toIso8601String();

      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('تم تحديث الملف الشخصي بنجاح');
      return true;

    } catch (e) {
      isLoading.value = false;
      print("ERROR updateProfile: $e");
      AppErrorHandler.showErrorSnack('$e');

      return false;
    }
  }

  Future<bool> changePassword(PasswordChange passwordChange) async {
    try {
      isLoading.value = true;

      await _apiService.post(
        '/api/accounts/change-password/',
        passwordChange.toJson(),
      );

      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('تم تغيير كلمة المرور بنجاح');
      return true;
    } catch (e) {
      isLoading.value = false;
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }
}