import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/company/job_form.dart';
import '../../data/models/company/paginated_job_form_list.dart';
import '../../data/services/job_forms_service.dart';
import '../../core/utils/error_handler.dart';
import 'CompanyController.dart';

class JobFormsController extends GetxController {
  final JobFormsService _service = JobFormsService();
  final CompanyController companyController = Get.find<CompanyController>();

  final RxList<JobForm> jobForms = <JobForm>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt currentPage = 1.obs;
  final RxInt totalCount = 0.obs;
  final RxBool hasNext = false.obs;

  final RxString searchQuery = ''.obs;
  final Rx<bool?> isActiveFilter = Rx<bool?>(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final RxBool isFormActive = true.obs;
  final RxList<FormQuestion> questions = <FormQuestion>[].obs;
  final RxBool isFormLoading = false.obs;
  final Rxn<int> selectedCompanyId = Rxn<int>();
  JobForm? _editingFormId;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    debounce(searchQuery, (_) => fetchJobForms(page: 1), time: const Duration(milliseconds: 500));
    fetchJobForms();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchJobForms({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
        jobForms.clear();
      }

      final PaginatedJobFormList response = await _service.getJobForms(
        page: page,
        search: searchQuery.value,
        isActive: isActiveFilter.value,
      );

      if (response.results != null) {
        if (page == 1) {
          jobForms.assignAll(response.results!);
        } else {
          jobForms.addAll(response.results!);
        }
      }

      totalCount.value = response.count ?? 0;
      hasNext.value = response.next != null;
      currentPage.value = page;
      print('the response in load forms is : ${response.results}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('error message in load forms is : ${errorMessage.value}');
      // AppErrorHandler.showErrorSnack('$e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilterStatus(bool? isActive) {
    if (isActiveFilter.value != isActive) {
      isActiveFilter.value = isActive;
      fetchJobForms(page: 1);
    }
  }

  Future<void> loadNextPage() async {
    if (!isLoading.value && hasNext.value) {
      await fetchJobForms(page: currentPage.value + 1);
    }
  }

  Future<void> deleteJobForm(int id) async {
    try {
      isLoading.value = true;
      final message = await _service.deleteJobForm(id);
      jobForms.removeWhere((form) => form.id == id);
      print('the message in delete form is : ${message.toString()}');
      Get.snackbar('نجاح', message ?? 'تم حذف النموذج بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('the error in delete message is : ${e.toString()}');
      AppErrorHandler.showErrorSnack('$e');
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form data when entering Create/Edit screen
  void initForm({JobForm? form}) async {
    _editingFormId = form;
    nameController.text = form?.name ?? '';
    descriptionController.text = form?.description ?? '';
    isFormActive.value = form?.isActive ?? true;
    if (companyController.myCompanies.isEmpty) {
      await companyController.getMyCompanies(showLoading: false);
    }

    if (form != null && form.company != null) {
      selectedCompanyId.value = form.company;
    } else if (companyController.myCompanies.isNotEmpty) {
      selectedCompanyId.value = companyController.myCompanies.first.id;
    } else {
      selectedCompanyId.value = null;
    }

    questions.clear();

    if (form?.questions != null) {
      questions.assignAll(form!.questions!);
      // Ensure specific sort order
      questions.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    }
  }

  void addQuestion() {
    questions.add(FormQuestion(
        label: '',
        questionType: 'text',
        required: false,
        order: questions.length + 1
    ));
  }

  void removeQuestion(int index) {
    questions.removeAt(index);
    _reorderQuestions();
  }

  void moveQuestionUp(int index) {
    if (index > 0) {
      final temp = questions[index];
      questions[index] = questions[index - 1];
      questions[index - 1] = temp;
      _reorderQuestions();
    }
  }

  void moveQuestionDown(int index) {
    if (index < questions.length - 1) {
      final temp = questions[index];
      questions[index] = questions[index + 1];
      questions[index + 1] = temp;
      _reorderQuestions();
    }
  }

  void _reorderQuestions() {
    for (int i = 0; i < questions.length; i++) {
      questions[i] = _copyWithOrder(questions[i], i + 1);
    }
  }

  FormQuestion _copyWithOrder(FormQuestion q, int newOrder) {
    return FormQuestion(
      id: q.id,
      label: q.label,
      helpText: q.helpText,
      questionType: q.questionType,
      required: q.required,
      options: q.options,
      order: newOrder,
    );
  }

  void updateQuestion(int index, FormQuestion updatedQuestion) {
    questions[index] = updatedQuestion;
  }

  Future<void> saveForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedCompanyId.value == null) {
        Get.snackbar('خطأ', 'يرجى اختيار الشركة', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (questions.isEmpty) {
        Get.snackbar('تنبيه', 'يجب إضافة سؤال واحد على الأقل', backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // Validate questions content
      for(int i=0; i < questions.length; i++) {
        if (questions[i].label == null || questions[i].label!.isEmpty) {
          Get.snackbar('خطأ', 'يرجى إدخال نص السؤال رقم ${i+1}', backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
        if (['select', 'checkbox'].contains(questions[i].questionType)) {
          if (questions[i].options == null || questions[i].options!.isEmpty) {
            Get.snackbar('خطأ', 'يرجى إدخال خيارات للسؤال رقم ${i+1}', backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }
        }
      }

      isFormLoading.value = true;

      final form = JobForm(
        id: _editingFormId?.id,
        name: nameController.text,
        description: descriptionController.text,
        isActive: isFormActive.value,
        questions: questions.toList(),
        company: selectedCompanyId.value,
      );

      try {
        if (_editingFormId == null) {
          // Create
          final response = await _service.createJobForm(form);
          final newForm = response['data'] as JobForm;
          jobForms.insert(0, newForm);
          Get.back();
         AppErrorHandler.showSuccessSnack('تم إنشاء النموذج بنجاح');
        } else {
          // Update
          final response = await _service.updateJobForm(_editingFormId!.id!, form);
          final updatedForm = response['data'] as JobForm;
          int index = jobForms.indexWhere((f) => f.id == updatedForm.id);
          if (index != -1) {
            jobForms[index] = updatedForm;
          }
          Get.back();
          AppErrorHandler.showSuccessSnack('تم تحديث النموذج بنجاح');
        }
      } catch (e) {
        print('the error in create form is : $e');
        AppErrorHandler.showErrorSnack('$e');
      } finally {
        isFormLoading.value = false;
      }
    }
  }
}
