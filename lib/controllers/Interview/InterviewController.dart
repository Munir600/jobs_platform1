import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/error_handler.dart';
import '../../data/services/Interview/InterviewService.dart';
import '../../data/models/Interview/Interview.dart';
import '../../data/models/Interview/InterviewCreate.dart';

class InterviewController extends GetxController {
  final InterviewService _interviewService = InterviewService();
  final GetStorage _storage = GetStorage();

  final RxList<Interview> interviews = <Interview>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
  }
  
  void loadCachedData() {
    try {
      final cachedInterviews = _storage.read('interviews_list');
      if (cachedInterviews != null && cachedInterviews is List) {
        interviews.assignAll(cachedInterviews.map((e) => Interview.fromJson(e)).toList());
      }
    } catch (e) {
      print('Error loading cached interviews: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadInterviews();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadInterviews() async {
    try {
      isLoading.value = true;
      final response = await _interviewService.getInterviews();
      if (response.results != null) {
        interviews.assignAll(response.results!);
        _storage.write('interviews_list', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Interview?> getInterview(int id) async {
    try {
      isLoading.value = true;
      // Try cache first
      final cachedInterview = _storage.read('interview_detail_$id');
      Interview? result;
      if (cachedInterview != null) {
        result = Interview.fromJson(cachedInterview);
      }

      final interview = await _interviewService.getInterview(id);
      if (interview != null) {
        _storage.write('interview_detail_$id', interview.toJson());
        result = interview;
      }
      return result;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
       // Return cached if available
      final cachedInterview = _storage.read('interview_detail_$id');
      if (cachedInterview != null) {
        return Interview.fromJson(cachedInterview);
      }
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createInterview(InterviewCreate interview) async {
    try {
      isLoading.value = true;
      await _interviewService.createInterview(interview);
      await loadInterviews();
      Get.snackbar('Success', 'Interview scheduled successfully');
      AppErrorHandler.showSuccessSnack('تم جدولة المقابلة بنجاح');

      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateInterview(int id, InterviewCreate interview) async {
    try {
      isLoading.value = true;
      await _interviewService.updateInterview(id, interview);
      await loadInterviews();
      Get.snackbar('Success', 'Interview updated successfully');
      AppErrorHandler.showSuccessSnack('تم تحديث المقابلة بنجاح');

      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
