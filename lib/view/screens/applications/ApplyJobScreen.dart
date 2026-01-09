import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplyJobController.dart';
import '../../../config/app_colors.dart';
import './widgets/internal_application_widget.dart';
import './widgets/custom_form_widget.dart';
import './widgets/template_application_widget.dart';
import './widgets/external_application_widget.dart';

class ApplyJobScreen extends GetView<ApplyJobController> {
  const ApplyJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'التقديم على: ${controller.jobTitle ?? ""}',
          style: const TextStyle(color: AppColors.textColor, fontSize: 18),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        final job = controller.jobDetail.value;
        if (job == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: _buildApplicationBody(job),
        );
      }),
    );
  }

  Widget _buildApplicationBody(dynamic job) {
    switch (job.applicationMethod) {
      case 'platform':
        return InternalApplicationWidget(controller: controller, job: job);
      case 'custom_form':
        return CustomFormWidget(controller: controller, job: job);
      case 'template_file':
        return TemplateApplicationWidget(controller: controller, job: job);
      case 'external_link':
      case 'email':
        return ExternalApplicationWidget(controller: controller, job: job);
      default:
        return InternalApplicationWidget(controller: controller, job: job);
    }
  }
}
