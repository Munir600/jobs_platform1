// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../config/app_colors.dart';
// import '../../../../controllers/Interview/InterviewController.dart';
//
// class EmployerInterviewsScreen extends GetView<InterviewController> {
//   const EmployerInterviewsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
//       }
//
//       if (controller.interviews.isEmpty) {
//         return const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.event_busy, size: 64, color: Colors.grey),
//               SizedBox(height: 16),
//               Text('لا توجد مقابلات مجدولة', style: TextStyle(fontSize: 18, color: Colors.grey)),
//             ],
//           ),
//         );
//       }
//
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: controller.interviews.length,
//         itemBuilder: (context, index) {
//           final interview = controller.interviews[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         interview.interviewTypeDisplay ?? interview.interviewType ?? 'مقابلة',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(interview.status).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           interview.statusDisplay ?? interview.status ?? '-',
//                           style: TextStyle(
//                             color: _getStatusColor(interview.status),
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         interview.scheduledDate?.replaceAll('T', ' ').substring(0, 16) ?? '-',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.person, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         'المتقدم: ${interview.application?.applicantName ?? 'غير معروف'}',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   if (interview.meetingLink != null) ...[
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () {
//                         // TODO: Launch URL
//                       },
//                       child: Row(
//                         children: [
//                           const Icon(Icons.link, size: 16, color: Colors.blue),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               interview.meetingLink!,
//                               style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   Color _getStatusColor(String? status) {
//     switch (status) {
//       case 'scheduled':
//         return Colors.blue;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }
