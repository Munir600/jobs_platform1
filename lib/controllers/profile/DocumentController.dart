import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/accounts/profile/document/document_create.dart';
import '../../data/models/accounts/profile/document/document_detail.dart';
import '../../data/models/accounts/profile/document/document_model.dart';
import '../../data/services/profile/jobseeker_document_service.dart';

class DocumentController extends GetxController {
  final JobseekerDocumentService _documentService = JobseekerDocumentService();
  final Dio _dio = Dio();

  final RxList<DocumentDetail> documents = <DocumentDetail>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalCount = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  Future<void> loadDocuments({bool refresh = false}) async {
    try {
      if (!refresh) isLoading.value = true;

      final response = await _documentService.listDocuments();
      documents.assignAll(response.results!);
      // totalCount.value = response.count;
      print('the response load document is : ${response.results}');
    } catch (e) {
      print('Error loading documents in contorller is : $e');
      AppErrorHandler.showErrorSnack(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadAndView(DocumentDetail document) async {
    try {
      if (document.fileUrl.isEmpty) {
        AppErrorHandler.showErrorSnack('رابط الملف غير متوفر');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final extension = document.fileUrl.split('.').last;
      final fileName = "doc_${document.id}.${extension}";
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        final result = await OpenFilex.open(file.path);
        if (result.type != ResultType.done) {
          AppErrorHandler.showErrorSnack('لا يمكن فتح الملف: ${result.message}');
        }
      } else {
        Get.dialog(
          const Center(child: CircularProgressIndicator(color: Colors.white)),
          barrierDismissible: false,
        );

        await _dio.download(document.fileUrl, file.path);

        if (Get.isDialogOpen ?? false) Get.back();

        final result = await OpenFilex.open(file.path);
        if (result.type != ResultType.done) {
          AppErrorHandler.showErrorSnack('لا يمكن فتح الملف المحمل: ${result.message}');
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      AppErrorHandler.showErrorSnack('حدث خطأ أثناء تحميل أو فتح الملف: ${e.toString()}');
    }
  }

  Future<bool> addDocument({
    required DocumentType documentType,
    required File file,
    required String title,
    String? description,
    String? issuedBy,
    DateTime? issueDate,
    DocumentVisibility? visibility,
  }) async {
    try {
      isLoading.value = true;

      final request = DocumentCreate(
        documentType: documentType.name,
        title: title,
        description: description,
        issuedBy: issuedBy,
        issueDate: issueDate,
        visibility: visibility?.value,
      );

      final result = await _documentService.createDocument(request, file);

      final newDoc = result['document'] as DocumentDetail;
      final serverMessage = result['message'] as String;

      documents.insert(0, newDoc);
      totalCount.value++;
      AppErrorHandler.showSuccessSnack(serverMessage);

      return true;

    } catch (e) {
      print('Error adding document: $e');
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateDocument(int id, {
    required DocumentType documentType,
    File? file,
    required String title,
    String? description,
    String? issuedBy,
    DateTime? issueDate,
    DocumentVisibility? visibility,
  }) async {
    try {
      isLoading.value = true;

      final request = DocumentCreate(
        documentType: documentType.name,
        title: title,
        description: description,
        issuedBy: issuedBy,
        issueDate: issueDate,
        visibility: visibility?.value,
      );

      final result = await _documentService.partialUpdateDocument(id, request, file: file);

      final updatedDoc = result['document'] as DocumentDetail;
      final serverMessage = result['message'] as String;

      final index = documents.indexWhere((doc) => doc.id == id);
      if (index != -1) {
        documents[index] = updatedDoc;
      }
      AppErrorHandler.showSuccessSnack(serverMessage);
      loadDocuments();
      return true;

    } catch (e) {
      print('Error updating document 55555: $e');
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      print('Error message errorMessage is : $errorMessage');
      AppErrorHandler.showErrorSnack(errorMessage);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDocument(int id) async {
    try {
      isLoading.value = true;
      final success = await _documentService.deleteDocument(id);
      if (success) {
        documents.removeWhere((doc) => doc.id == id);
        totalCount.value--;
        AppErrorHandler.showSuccessSnack('تم حذف الوثيقة بنجاح');
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting document: $e');
      AppErrorHandler.showErrorSnack(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setSearch(String query) {
    searchQuery.value = query;
    loadDocuments();
  }
}

