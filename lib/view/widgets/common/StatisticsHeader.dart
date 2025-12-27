// import 'package:flutter/material.dart';
// import '../../../config/app_colors.dart';
//
// class StatisticsHeader extends StatelessWidget {
//   final int totalCount;
//   final int currentPage;
//   final int pageSize;
//   final String itemNameSingular; // e.g., "وظيفة"
//   final String itemNamePlural; // e.g., "وظائف"
//
//   const StatisticsHeader({
//     super.key,
//     required this.totalCount,
//     required this.currentPage,
//     required this.pageSize,
//     required this.itemNameSingular,
//     required this.itemNamePlural,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (totalCount == 0) {
//       return const SizedBox.shrink();
//     }
//
//     final startItem = ((currentPage - 1) * pageSize) + 1;
//     final endItem = (currentPage * pageSize > totalCount)
//         ? totalCount
//         : currentPage * pageSize;
//
//     final itemName = totalCount == 1 ? itemNameSingular : itemNamePlural;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: AppColors.accentColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Current range
//           Expanded(
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.filter_list,
//                   size: 18,
//                   color: AppColors.primaryColor,
//                 ),
//                 const SizedBox(width: 8),
//                 Flexible(
//                   child: Text(
//                     'عرض $startItem-$endItem من أصل $totalCount $itemName',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textColor,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Page indicator
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               'صفحة $currentPage',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
