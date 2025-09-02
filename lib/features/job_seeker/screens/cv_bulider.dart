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

  // Dynamic lists
  List<Experience> experiences = [];
  List<Education> educations = [];

  @override
  void initState() {
    super.initState();
    // إضافة عنصر افتراضي لكل من الخبرة والتعليم
    experiences.add(Experience());
    educations.add(Education());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📄 منشئ السيرة الذاتية"),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // -------- المعلومات الشخصية --------
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

              const SizedBox(height: 16),

              // -------- الخبرة العملية --------
              _sectionTitle("الخبرة العملية"),
              ..._buildExperienceFields(),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    experiences.add(Experience());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة خبرة عملية"),
              ),

              const SizedBox(height: 16),

              // -------- التعليم --------
              _sectionTitle("التعليم"),
              ..._buildEducationFields(),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    educations.add(Education());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة مؤهل تعليمي"),
              ),

              const SizedBox(height: 16),

              // -------- المهارات --------
              _sectionTitle("المهارات"),
              _formField("المهارات (افصل بينها بفاصلة)", skillsController,
                  maxLines: 2),

              const SizedBox(height: 24),

              // -------- معاينة --------
              _sectionTitle("معاينة السيرة الذاتية"),
              _buildPreview(),

              const SizedBox(height: 24),

              // -------- حفظ أو طباعة (مستقبلياً) --------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("ميزة الطباعة / PDF ستضاف لاحقاً")),
                      );
                    },
                    child: const Text("تحميل PDF"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
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
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء ملء هذا الحقل';
        }
        return null;
      },
      onChanged: (_) {
        setState(() {}); // تحديث المعاينة مباشرة
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "خبرة ${idx + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "مؤهل ${idx + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${firstNameController.text} ${lastNameController.text}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(jobTitleController.text,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                if (emailController.text.isNotEmpty)
                  Text("📧 ${emailController.text}"),
                if (phoneController.text.isNotEmpty)
                  Text("📞 ${phoneController.text}"),
                if (cityController.text.isNotEmpty) Text("🏙️ ${cityController.text}"),
              ],
            ),
            if (summaryController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text("نبذة مختصرة:",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(summaryController.text),
            ],
            if (experiences.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text("الخبرة العملية:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: experiences
                    .map((exp) => ListTile(
                  title: Text(exp.titleController.text),
                  subtitle: Text(
                      "${exp.companyController.text} (${exp.startController.text} - ${exp.endController.text})\n${exp.descController.text}"),
                ))
                    .toList(),
              ),
            ],
            if (educations.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text("التعليم:", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: educations
                    .map((edu) => ListTile(
                  title: Text(edu.degreeController.text),
                  subtitle: Text(
                      "${edu.institutionController.text} (${edu.yearController.text}) - ${edu.gradeController.text}"),
                ))
                    .toList(),
              ),
            ],
            if (skillsController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text("المهارات:", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: skillsController.text
                    .split(',')
                    .map((skill) => Chip(label: Text(skill.trim())))
                    .toList(),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ----------- Models -------------
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
