import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../controllers/profile/DocumentController.dart';
import '../../core/constants.dart';
import '../../data/models/accounts/profile/document/document_detail.dart';
import '../../data/models/accounts/profile/document/document_model.dart';

class DocumentFormDialog extends GetView<DocumentController> {
  final DocumentDetail? document;

  const DocumentFormDialog({super.key, this.document});

  @override
  Widget build(BuildContext context) {
    final isEditing = document != null;
    final titleController = TextEditingController(text: document?.title);
    final descController = TextEditingController(text: document?.description);
    final issuedByController = TextEditingController(text: document?.issuedBy);

    final Rx<DocumentType> selectedType = (DocumentType.values.firstWhere(
            (e) => e.name == document?.documentType,
        orElse: () => DocumentType.certificate
    )).obs;

    final Rx<DocumentVisibility> selectedVisibility = (DocumentVisibility.fromString(document?.visibility)).obs;
    final Rx<DateTime?> selectedDate = (document?.issueDate).obs;
    final Rx<File?> selectedFile = Rx<File?>(null);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.accentColor,
      insetPadding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
              color: AppColors.primaryColor,
            ),
            child: Row(
              children: [
                Text(
                  isEditing ? 'تعديل الوثيقة' : 'إضافة وثيقة جديدة',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.black),
                  onPressed: () => Get.back(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabel('عنوان الوثيقة*'),
                  _buildTextField(titleController, 'مثال: شهادة PMP'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('النوع'),
                            Obx(() => _buildDropdown<DocumentType>(
                              value: selectedType.value,
                              items: DocumentType.values.map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(_getTypeLabel(t.name), style: const TextStyle(fontSize: 13)),
                              )).toList(),
                              onChanged: (v) => selectedType.value = v!,
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('الخصوصية'),
                            Obx(() => _buildDropdown<DocumentVisibility>(
                              value: selectedVisibility.value,
                              items: DocumentVisibility.values.map((v) => DropdownMenuItem(
                                value: v,
                                child: Text(_getVisibilityLabel(v.value), style: const TextStyle(fontSize: 13)),
                              )).toList(),
                              onChanged: (v) => selectedVisibility.value = v!,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('جهة الإصدار'),
                  _buildTextField(issuedByController, 'الجهة المانحة'),
                  const SizedBox(height: 16),

                  _buildLabel('تاريخ الإصدار'),
                  Obx(() => _buildDateSelector(context, selectedDate.value, (d) => selectedDate.value = d)),
                  const SizedBox(height: 16),

                  _buildLabel('الوصف'),
                  _buildTextField(descController, 'تفاصيل إضافية...', maxLines: 3),
                  const SizedBox(height: 16),

                  _buildLabel('ملف الوثيقة ${isEditing ? "(اختياري)" : "*"}'),
                  Obx(() => _buildFileSelector(selectedFile.value, isEditing, () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
                    );
                    if (result != null && result.files.single.path != null) {
                      selectedFile.value = File(result.files.single.path!);
                    }
                  })),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: Colors.blueGrey,
                    ),
                    child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty) {
                        Get.snackbar('تنبيه', 'يرجى إدخال عنوان الوثيقة',
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[50], colorText: Colors.red);
                        return;
                      }
                      if (!isEditing && selectedFile.value == null) {
                        Get.snackbar('تنبيه', 'يرجى اختيار ملف الوثيقة',
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[50], colorText: Colors.red);
                        return;
                      }

                      bool success;
                      if (isEditing) {
                        success = await controller.updateDocument(
                          document!.id,
                          title: titleController.text,
                          documentType: selectedType.value,
                          description: descController.text,
                          issuedBy: issuedByController.text,
                          issueDate: selectedDate.value,
                          visibility: selectedVisibility.value,
                          file: selectedFile.value,
                        );
                      } else {
                        success = await controller.addDocument(
                          documentType: selectedType.value,
                          title: titleController.text,
                          file: selectedFile.value!,
                          description: descController.text,
                          issuedBy: issuedByController.text,
                          issueDate: selectedDate.value,
                          visibility: selectedVisibility.value,
                        );
                      }

                      if (success) {
                        Navigator.of(context).pop(); // Close dialog explicitly
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child:  Obx(() => controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isEditing ? 'حفظ التعديلات' : 'إضافة الوثيقة',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textColor)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.blueGrey),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime? date, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(
              date == null ? 'اختر التاريخ' : DateFormat('yyyy-MM-dd').format(date),
              style: TextStyle(fontSize: 13, color: date == null ? Colors.grey : AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelector(File? file, bool isEditing, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Icon(
                file != null ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                color: file != null ? Colors.green : AppColors.primaryColor,
                size: 24
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file != null
                    ? file.path.split(Platform.pathSeparator).last
                    : (isEditing ? 'إبقاء الملف الحالي (اضغط للتغيير)' : 'اضغط لاختيار ملف (.pdf, .doc, .docx, .txt, .rtf)'),
                style: TextStyle(
                    fontSize: 12,
                    color: file != null ? Colors.black87 : Colors.grey[600],
                    fontWeight: file != null ? FontWeight.bold : FontWeight.normal
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(String? type) => AppEnums.documentType[type] ?? 'أخرى';

  String _getVisibilityLabel(String? visibility) => AppEnums.visibility[visibility] ?? 'خاص';
}
