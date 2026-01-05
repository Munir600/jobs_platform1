import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../controllers/profile/DocumentController.dart';
import '../../core/constants.dart';
import '../../data/models/accounts/profile/document/document_detail.dart';

class DocumentCard extends GetView<DocumentController> {
  final DocumentDetail document;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DocumentCard({
    Key? key,
    required this.document,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withAlpha(5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getTypeLabel(document.documentType),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Privacy Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getVisibilityColor(document.visibility).withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('الخصوصية : ${_getVisibilityLabel(document.visibility)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getVisibilityColor(document.visibility),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.description_rounded, size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text( 'الوصف : ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                            document.description ?? '-',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Details Grid
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildDetailItem(Icons.business_rounded, 'جهة الإصدار', document.issuedBy ?? '-'),
                          _buildDetailItem(
                              Icons.calendar_today_rounded,
                              'تاريخ الإصدار',
                              document.issueDate != null
                                  ? DateFormat('yyyy-MM-dd').format(document.issueDate!)
                                  : '-'
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.edit_rounded,
                      color: Colors.blueGrey,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 4),
                    _buildIconButton(
                      icon: Icons.delete_rounded,
                      color: Colors.red[400]!,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDetailItem(Icons.description, 'اسم الملف', document.fileName ?? '-'),
                _buildDetailItem(Icons.format_size, ' الحجم', document.fileSize ?? '-'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.downloadAndView(document),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: Text('عرض (${document.viewsCount})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.downloadAndView(document),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('تحميل', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey[300]),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Colors.blueGrey[400])),
            Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  String _getVisibilityLabel(String? visibility) => AppEnums.visibility[visibility] ?? 'خاص';
  String _getTypeLabel(String? type) => AppEnums.documentType[type] ?? 'أخرى';

  Color _getVisibilityColor(String? visibility) {
    if (visibility == 'public') return Colors.green;
    if (visibility == 'connections') return Colors.blue;
    return Colors.grey;
  }
}
