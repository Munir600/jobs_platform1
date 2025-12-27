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
  final RxBool isListLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  
  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalCount = 0.obs;
  final RxBool hasNextPage = false.obs;
  
  // Statistics
  final RxMap<String, int> statistics = <String, int>{}.obs;

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
      isListLoading.value = true;
      currentPage.value = 1;
      
      final response = await _interviewService.getInterviews(page: 1);
      if (response.results != null) {
        interviews.assignAll(response.results!);
        _storage.write('interviews_list', response.results!.map((e) => e.toJson()).toList());
        
        // Update pagination info
        totalCount.value = response.count ?? 0;
        hasNextPage.value = response.next != null;
        
        // Calculate statistics
        _calculateStatistics();
      }
    } catch (e) {
      print('Error loading interviews in controller: $e');
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
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
     // AppErrorHandler.showErrorSnack(e);
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
      AppErrorHandler.showSuccessSnack('تم جدولة المقابلة بنجاح');
      await loadInterviews();
      Get.back();
      return true;

    } catch (e) {
      print('Error creating interview: $e');
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
      AppErrorHandler.showSuccessSnack('تم تحديث المقابلة بنجاح');

      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreInterviews() async {
    if (!hasNextPage.value || isLoadingMore.value) return;
    
    try {
      isLoadingMore.value = true;
      final nextPage = currentPage.value + 1;
      
      final response = await _interviewService.getInterviews(page: nextPage);
      if (response.results != null && response.results!.isNotEmpty) {
        interviews.addAll(response.results!);
        currentPage.value = nextPage;
        hasNextPage.value = response.next != null;
        
        // Update cache
        _storage.write('interviews_list', interviews.map((e) => e.toJson()).toList());
        
        // Recalculate statistics
        _calculateStatistics();
      }
    } catch (e) {
      print('Error loading more interviews: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _calculateStatistics() {
    final stats = <String, int>{
      'total': interviews.length,
      'scheduled': 0,
      'completed': 0,
      'cancelled': 0,
      'rescheduled': 0,
    };
    
    for (var interview in interviews) {
      final status = interview.status?.toLowerCase() ?? '';
      if (stats.containsKey(status)) {
        stats[status] = (stats[status] ?? 0) + 1;
      }
    }
    
    statistics.value = stats;
  }
}
