import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  List<Experience> experiences = [];
  List<Education> educations = [];

  @override
  void initState() {
    super.initState();
    experiences.add(Experience());
    educations.add(Education());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text("📄 منشئ السيرة الذاتية"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sectionTitle("المعلومات الشخصية"),
              _formRow([
                _formField("الاسم الأول", firstNameController),
                _formField("الاسم الأخير", lastNameController),
              ]),
              _formField("المسمى الوظيفي", jobTitleController),
              _formRow([
                _formField("البريد الإلكتروني", emailController,
                    keyboardType: TextInputType.emailAddress),
                _formField("رقم الهاتف", phoneController,
                    keyboardType: TextInputType.phone),
              ]),
              _formRow([
                _formField("المدينة", cityController),
                _formField("الموقع الإلكتروني", websiteController,
                    keyboardType: TextInputType.url),
              ]),
              _formField("نبذة مختصرة", summaryController, maxLines: 4),

              const SizedBox(height: 20),
              _sectionTitle("الخبرة العملية"),
              ..._buildExperienceFields(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: () {
                  setState(() {
                    experiences.add(Experience());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة خبرة عملية"),
              ),

              const SizedBox(height: 20),
              _sectionTitle("التعليم"),
              ..._buildEducationFields(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: () {
                  setState(() {
                    educations.add(Education());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة مؤهل تعليمي"),
              ),

              const SizedBox(height: 20),
              _sectionTitle("المهارات"),
              _formField("المهارات (افصل بينها بفاصلة)", skillsController,
                  maxLines: 2),

              const SizedBox(height: 30),
              _sectionTitle("معاينة السيرة الذاتية"),
              _buildPreview(),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700]),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم حفظ البيانات")),
                        );
                      }
                    },
                    child: const Text("حفظ"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("ميزة الطباعة / PDF ستضاف لاحقاً")),
                      );
                    },
                    child: const Text("تحميل PDF"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _formField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueGrey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء ملء هذا الحقل';
        }
        return null;
      },
      onChanged: (_) {
        setState(() {});
      },
    );
  }

  Widget _formRow(List<Widget> fields) {
    return Row(
      children: fields
          .map((f) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: f,
        ),
      ))
          .toList(),
    );
  }

  List<Widget> _buildExperienceFields() {
    return experiences.asMap().entries.map((entry) {
      int idx = entry.key;
      Experience exp = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "خبرة ${idx + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        experiences.removeAt(idx);
                      });
                    },
                  )
                ],
              ),
              _formField("المسمى الوظيفي", exp.titleController),
              _formField("اسم الشركة", exp.companyController),
              _formRow([
                _formField("تاريخ البداية", exp.startController),
                _formField("تاريخ النهاية", exp.endController),
              ]),
              _formField("وصف المهام", exp.descController, maxLines: 3),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildEducationFields() {
    return educations.asMap().entries.map((entry) {
      int idx = entry.key;
      Education edu = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "مؤهل ${idx + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        educations.removeAt(idx);
                      });
                    },
                  )
                ],
              ),
              _formField("الدرجة العلمية", edu.degreeController),
              _formField("اسم المؤسسة", edu.institutionController),
              _formRow([
                _formField("سنة التخرج", edu.yearController),
                _formField("التقدير", edu.gradeController),
              ]),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPreview() {
    return Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
        padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "${firstNameController.text} ${lastNameController.text}",
    style: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent),
    ),
    Text(jobTitleController.text,
    style: const TextStyle(fontSize: 16, color: Colors.grey)),
    const             SizedBox(height: 8),
      Row(
        children: [
          if (emailController.text.isNotEmpty)
            Text(emailController.text,
                style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          if (phoneController.text.isNotEmpty)
            Text(phoneController.text,
                style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          if (cityController.text.isNotEmpty)
            Text(cityController.text,
                style: const TextStyle(color: Colors.grey)),
        ],
      ),
      const SizedBox(height: 12),
      if (summaryController.text.isNotEmpty) ...[
        const Text("نبذة مختصرة",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent)),
        const SizedBox(height: 4),
        Text(summaryController.text),
        const SizedBox(height: 12),
      ],

      if (experiences.isNotEmpty) ...[
        const Text("الخبرة العملية",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent)),
        const SizedBox(height: 4),
        Column(
          children: experiences.map((exp) {
            if (exp.titleController.text.isEmpty &&
                exp.companyController.text.isEmpty) return Container();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp.titleController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(exp.companyController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent)),
                  Text(
                      "${exp.startController.text} - ${exp.endController.text}",
                      style: const TextStyle(color: Colors.grey)),
                  if (exp.descController.text.isNotEmpty)
                    Text(exp.descController.text),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],

      if (educations.isNotEmpty) ...[
        const Text("التعليم",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent)),
        const SizedBox(height: 4),
        Column(
          children: educations.map((edu) {
            if (edu.degreeController.text.isEmpty &&
                edu.institutionController.text.isEmpty) return Container();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(edu.degreeController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(edu.institutionController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent)),
                  Text(edu.yearController.text,
                      style: const TextStyle(color: Colors.grey)),
                  if (edu.gradeController.text.isNotEmpty)
                    Text("التقدير: ${edu.gradeController.text}"),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],

      if (skillsController.text.isNotEmpty) ...[
        const Text("المهارات",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: skillsController.text
              .split(',')
              .map((s) => Chip(
            label: Text(s.trim()),
            backgroundColor: Colors.blueAccent,
            labelStyle:
            const TextStyle(color: Colors.white, fontSize: 14),
          ))
              .toList(),
        ),
      ],
    ],
    ),
        ),
    );
  }
}

// ------------------- Models -------------------
class Experience {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController descController = TextEditingController();
}

class Education {
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
}

