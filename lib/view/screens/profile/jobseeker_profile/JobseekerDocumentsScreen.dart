import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/profile/DocumentController.dart';
import '../../../../core/constants.dart';
import '../../../../data/models/accounts/profile/document/document_detail.dart';
import '../../../../data/models/accounts/profile/document/document_model.dart' hide AppEnums;




class JobseekerDocumentsScreen extends StatelessWidget {
  JobseekerDocumentsScreen({super.key});

  final DocumentController controller = Get.put(DocumentController(),permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('إدارة الوثائق',
            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadDocuments(refresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.documents.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.documents.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadDocuments(refresh: true),
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.documents.length,
                  itemBuilder: (context, index) {
                    final document = controller.documents[index];
                    return _buildDocumentCard(context, document);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDocumentDialog(context),
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إضافة وثيقة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => controller.setSearch(value),
        decoration: InputDecoration(
          hintText: 'البحث عن وثيقة...',
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.folder_open_rounded, size: 100, color: Colors.blue.withOpacity(0.3)),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد وثائق مضافة',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Text(
            'قم بإضافة شهاداتك وجوائزك لتعزيز ملفك',
            style: TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
          ),
          const SizedBox(height: 32),

        ],
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, DocumentDetail document) {
    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            document.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${_getTypeLabel(document.documentType)} • ${document.issuedBy ?? 'جهة غير محددة'}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor.withOpacity(0.6),
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFE2E8F0), height: 32),
                  if (document.description != null && document.description!.isNotEmpty) ...[
                    _buildFullDetailItem('الوصف', document.description!),
                    const SizedBox(height: 16),
                  ],
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildMiniDetail('ID', '#${document.id}'),
                      _buildMiniDetail('نوع الوثيقة', _getTypeLabel(document.documentType)),
                      _buildMiniDetail('جهة الإصدار', document.issuedBy ?? 'غير محدد'),
                      _buildMiniDetail('تاريخ الإصدار', document.issueDate != null ? DateFormat('yyyy-MM-dd').format(document.issueDate!) : 'غير محدد'),
                      _buildMiniDetail('الخصوصية', _getVisibilityLabel(document.visibility)),
                      _buildMiniDetail('المشاهدات', '${document.viewsCount}'),
                      _buildMiniDetail('حجم الملف', document.fileSize),
                      _buildMiniDetail('اسم الملف', document.fileName),
                      _buildMiniDetail('تاريخ الإضافة', document.createdAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(document.createdAt!) : '-'),
                      _buildMiniDetail('آخر تحديث', document.updatedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(document.updatedAt!) : '-'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showDocumentDialog(context, document: document),
                        icon: const Icon(Icons.edit, size: 18, color: AppColors.primaryColor),
                        label: const Text('تعديل', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _confirmDelete(context, document),
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        label: const Text('حذف', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => controller.downloadAndView(document),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.visibility, color: Colors.white, size: 18),
                        label: const Text('عرض الوثيقة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textColor)),
      ],
    );
  }

  Widget _buildMiniDetail(String label, String value) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }


  Widget _buildLabelTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _buildInfoTag(IconData icon, String label, String value, {bool isFull = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[400]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.blueGrey[300], fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value,
                  style: const TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[800]))),
        ],
      ),
    );
  }

  Widget _getDocumentIcon(String? typeStr) {
    IconData iconData;
    Color color;

    switch (typeStr) {
      case 'certificate':
        iconData = Icons.workspace_premium_rounded;
        color = const Color(0xFFF59E0B); // Amber
        break;
      case 'training':
        iconData = Icons.school_rounded;
        color = const Color(0xFF3B82F6); // Blue
        break;
      case 'award':
        iconData = Icons.emoji_events_rounded;
        color = const Color(0xFFEC4899); // Pink
        break;
      case 'project':
        iconData = Icons.account_tree_rounded;
        color = const Color(0xFF10B981); // Emerald
        break;
      default:
        iconData = Icons.description_rounded;
        color = const Color(0xFF64748B); // Slate
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(iconData, color: color, size: 26),
    );
  }

  String _getTypeLabel(String? type) {
    return AppEnums.documentType[type] ?? 'أخرى';
  }

  String _getVisibilityLabel(String? visibility) {
    return AppEnums.visibility[visibility] ?? 'خاص';
  }

  void _showDocumentDialog(BuildContext context, {DocumentDetail? document}) {
    final isEditing = document != null;
    final titleController = TextEditingController(text: document?.title);
    final descController = TextEditingController(text: document?.description);
    final issuedByController = TextEditingController(text: document?.issuedBy);

    Rx<DocumentType> selectedType = (DocumentType.values.firstWhere(
            (e) => e.name == document?.documentType,
        orElse: () => DocumentType.certificate
    )).obs;

    Rx<DocumentVisibility> selectedVisibility = (DocumentVisibility.fromString(document?.visibility)).obs;
    Rx<DateTime?> selectedDate = (document?.issueDate).obs;
    Rx<File?> selectedFile = Rx<File?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditing ? 'تعديل وثيقة' : 'إضافة وثيقة جديدة',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildInputLabel('عنوان الوثيقة*'),
                    _buildTextField(titleController, 'مثال: شهادة إنجاز دورة البرمجة'),
                    const SizedBox(height: 16),
                    _buildInputLabel('نوع الوثيقة'),
                    Obx(() => _buildDropdown<DocumentType>(
                      value: selectedType.value,
                      items: DocumentType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getTypeLabel(type.name)),
                      )).toList(),
                      onChanged: (v) => selectedType.value = v!,
                    )),
                    const SizedBox(height: 16),
                    _buildInputLabel('جهة الإصدار'),
                    _buildTextField(issuedByController, 'اسم المؤسسة أو الشركة'),
                    const SizedBox(height: 16),
                    _buildInputLabel('تاريخ الإصدار'),
                    Obx(() => _buildDateSelector(context, selectedDate.value, (date) => selectedDate.value = date)),
                    const SizedBox(height: 16),
                    _buildInputLabel('الوصف'),
                    _buildTextField(descController, 'اكتب وصفاً مختصراً للوثيقة...', maxLines: 3),
                    const SizedBox(height: 16),
                    _buildInputLabel('الخصوصية'),
                    Obx(() => _buildDropdown<DocumentVisibility>(
                      value: selectedVisibility.value,
                      items: DocumentVisibility.values.map((v) => DropdownMenuItem(
                        value: v,
                        child: Text(_getVisibilityLabel(v.value)),
                      )).toList(),
                      onChanged: (v) => selectedVisibility.value = v!,
                    )),
                    const SizedBox(height: 16),
                    _buildInputLabel('الملف*'),
                    Obx(() => _buildFileSelector(selectedFile.value, isEditing, () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      if (result != null) selectedFile.value = File(result.files.single.path!);
                    })),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty) {
                          Get.snackbar('تنبيه', 'يرجى إدخال العنوان', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        if (!isEditing && selectedFile.value == null) {
                          Get.snackbar('تنبيه', 'يرجى اختيار ملف الوثيقة', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        bool success;
                        if (isEditing) {
                          success = await controller.updateDocument(
                            document.id,
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

                        if (success) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      child: Obx(() => controller.isLoading.value
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isEditing ? 'تعديل الوثيقة' : 'حفظ الوثيقة',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF64748B))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey[200], fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueGrey),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded, size: 20, color: Colors.blueGrey[400]),
            const SizedBox(width: 12),
            Text(
              date == null ? 'اختر التاريخ' : DateFormat('yyyy-MM-dd').format(date),
              style: TextStyle(color: date == null ? Colors.blueGrey[200] : const Color(0xFF334155)),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.1), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.upload_file_rounded, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file != null ? file.path.split(Platform.pathSeparator).last : (isEditing ? 'تغيير الملف الحالي' : 'ارفع الملف'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (file == null && !isEditing)
                    Text('PDF, DOC, JPG (max 5MB)', style: TextStyle(color: Colors.blueGrey[300], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DocumentDetail document) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('حذف الوثيقة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('هل أنت متأكد من حذف "${document.title}"؟\nلا يمكن التراجع عن هذا الإجراء.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey[600]),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text('إلغاء', style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await controller.deleteDocument(document.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('حذف الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
