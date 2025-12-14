// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../config/app_colors.dart';
// import '../../../../controllers/Interview/InterviewController.dart';
//
// class JobSeekerInterviewsScreen extends GetView<InterviewController> {
//   const JobSeekerInterviewsScreen({super.key});
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
//           child: Text('لا توجد مقابلات مجدولة', style: TextStyle(color: Colors.grey)),
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
//                         interview.interviewTypeDisplay ?? 'مقابلة',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           interview.statusDisplay ?? 'مجدولة',
//                           style: TextStyle(color: Colors.blue[800], fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text('التاريخ: ${interview.scheduledDate?.replaceAll('T', ' ') ?? '-'}'),
//                   if (interview.durationMinutes != null)
//                     Text('المدة: ${interview.durationMinutes} دقيقة'),
//                   const SizedBox(height: 16),
//                   if (interview.meetingLink != null)
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           final uri = Uri.parse(interview.meetingLink!);
//                           if (await canLaunchUrl(uri)) {
//                             await launchUrl(uri);
//                           } else {
//                             Get.snackbar('Error', 'Could not launch ${interview.meetingLink}');
//                           }
//                         },
//                         icon: const Icon(Icons.video_call),
//                         label: const Text('انضمام للاجتماع'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primaryColor,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
