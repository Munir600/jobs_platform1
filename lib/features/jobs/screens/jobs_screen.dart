import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

// ---------------------------
// نموذج بيانات الوظيفة
// ---------------------------
class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String date;
  final String description;
  final List<String> tags;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.date,
    required this.description,
    required this.tags,
  });
}

// ---------------------------
// شاشة عرض الوظائف مع الفلاتر + البحث
// ---------------------------
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}
class _JobsScreenState extends State<JobsScreen> {

  final List<Job> jobs = [
    Job(
      id: "101",
      title: "مطور تطبيقات الويب الأمامية",
      company: "شركة التقنيات المتقدمة",
      location: "📍 صنعاء",
      salary: "💰 800-1200 ريال/شهر",
      type: "دوام كامل",
      date: "منذ يومين",
      description:
      "نبحث عن مطور ويب متمرس للانضمام إلى فريقنا. خبرة في React و Vue.js مطلوبة.",
      tags: ["React", "JavaScript", "CSS", "Vue.js"],
    ),
    Job(
      id: "102",
      title: "مطور تطبيقات الجوال",
      company: "استوديو الابتكار للتطبيقات",
      location: "📍 صنعاء",
      salary: "💰 1000-1500 ريال/شهر",
      type: "دوام كامل",
      date: "منذ 3 أيام",
      description:
      "مطلوب مطور تطبيقات جوال بخبرة في Flutter أو React Native لتطوير تطبيقات حديثة.",
      tags: ["Flutter", "React Native", "Dart", "Mobile UI"],
    ),
    Job(
      id: "103",
      title: "مطور Full Stack",
      company: "شركة الحلول الرقمية",
      location: "📍 صنعاء",
      salary: "💰 1200-1800 ريال/شهر",
      type: "عقد مؤقت",
      date: "منذ أسبوع",
      description:
      "مطور Full Stack للعمل على مشاريع متنوعة. خبرة في Node.js و Python مطلوبة.",
      tags: ["Node.js", "Python", "MongoDB", "API Development"],
    ),
  ];

  // الفلاتر المحددة
  String selectedJobType = "";
  String selectedExperience = "";
  String selectedSalary = "";
  String selectedDate = "";
  String searchQuery = "";

  // دالة الفلترة + البحث
  List<Job> getFilteredJobs() {
    return jobs.where((job) {
      bool match = true;

      // فلترة حسب نوع الوظيفة
      if (selectedJobType.isNotEmpty) {
        match = match && job.type == selectedJobType;
      }

      // فلترة حسب نطاق الراتب
      if (selectedSalary.isNotEmpty) {
        if (selectedSalary == "أقل من 500 ريال") {
          match = match && _extractSalary(job.salary) < 500;
        } else if (selectedSalary == "500-1000 ريال") {
          match = match &&
              _extractSalary(job.salary) >= 500 &&
              _extractSalary(job.salary) <= 1000;
        } else if (selectedSalary == "1000-1500 ريال") {
          match = match &&
              _extractSalary(job.salary) >= 1000 &&
              _extractSalary(job.salary) <= 1500;
        } else if (selectedSalary == "أكثر من 1500 ريال") {
          match = match && _extractSalary(job.salary) > 1500;
        }
      }

      // فلترة حسب البحث
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        match = match &&
            (job.title.toLowerCase().contains(query) ||
                job.company.toLowerCase().contains(query) ||
                job.description.toLowerCase().contains(query) ||
                job.tags.any((tag) => tag.toLowerCase().contains(query)));
      }

      return match;
    }).toList();
  }

  int _extractSalary(String salary) {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(salary);
    if (match != null) {
      return int.tryParse(match.group(0) ?? "0") ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = getFilteredJobs();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Center(child: const Text("الوظائف المتاحة"
        ,style: TextStyle(
            fontSize: 24,
          ),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      // لا يعمل حاليا
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("الفلاتر",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            // نوع الوظيفة
            ExpansionTile(
              title: const Text("نوع الوظيفة"),
              children: [
                _buildFilterOption("دوام كامل", selectedJobType, (val) {
                  setState(() => selectedJobType = val);
                }),
                _buildFilterOption("دوام جزئي", selectedJobType, (val) {
                  setState(() => selectedJobType = val);
                }),
                _buildFilterOption("عقد مؤقت", selectedJobType, (val) {
                  setState(() => selectedJobType = val);
                }),
                _buildFilterOption("عمل عن بُعد", selectedJobType, (val) {
                  setState(() => selectedJobType = val);
                }),
              ],
            ),

            // مستوى الخبرة
            ExpansionTile(
              title: const Text("مستوى الخبرة"),
              children: [
                _buildFilterOption("مبتدئ (0-2 سنة)", selectedExperience, (val) {
                  setState(() => selectedExperience = val);
                }),
                _buildFilterOption("متوسط (3-5 سنوات)", selectedExperience, (val) {
                  setState(() => selectedExperience = val);
                }),
                _buildFilterOption("خبير (6+ سنوات)", selectedExperience, (val) {
                  setState(() => selectedExperience = val);
                }),
              ],
            ),

            // نطاق الراتب
            ExpansionTile(
              title: const Text("نطاق الراتب"),
              children: [
                _buildFilterOption("أقل من 500 ريال", selectedSalary, (val) {
                  setState(() => selectedSalary = val);
                }),
                _buildFilterOption("500-1000 ريال", selectedSalary, (val) {
                  setState(() => selectedSalary = val);
                }),
                _buildFilterOption("1000-1500 ريال", selectedSalary, (val) {
                  setState(() => selectedSalary = val);
                }),
                _buildFilterOption("أكثر من 1500 ريال", selectedSalary, (val) {
                  setState(() => selectedSalary = val);
                }),
              ],
            ),

            // تاريخ النشر
            ExpansionTile(
              title: const Text("تاريخ النشر"),
              children: [
                _buildFilterOption("اليوم", selectedDate, (val) {
                  setState(() => selectedDate = val);
                }),
                _buildFilterOption("آخر أسبوع", selectedDate, (val) {
                  setState(() => selectedDate = val);
                }),
                _buildFilterOption("آخر شهر", selectedDate, (val) {
                  setState(() => selectedDate = val);
                }),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق Drawer
                      setState(() {});
                    },
                    child: const Text("تطبيق"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedJobType = "";
                        selectedExperience = "";
                        selectedSalary = "";
                        selectedDate = "";
                        searchQuery = "";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("مسح الكل"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // مربع البحث
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ابحث عن وظيفة...",
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              style: TextStyle(color: AppColors.textColor),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // عرض الوظائف
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(child: Text("لا توجد وظائف مطابقة"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return JobCard(
                  job: job,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(job: job),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء خيار الفلتر
  Widget _buildFilterOption(
      String text, String selectedValue, Function(String) onSelected) {
    return RadioListTile(
      value: text,
      groupValue: selectedValue,
      onChanged: (val) => onSelected(val as String),
      title: Text(text),
    );
  }
}

// ---------------------------
// بطاقة عرض الوظيفة
// ---------------------------
class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(job.company,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(job.location),
                  Text(job.salary),
                  Text(job.type),
                  Text(job.date),
                ],
              ),
              const SizedBox(height: 8),
              Text(job.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: job.tags
                    .map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor:AppColors.accentColor ,
                ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("تقديم الآن"),

                  ),
                  OutlinedButton(onPressed: () {}, child: const Text("حفظ")),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// شاشة تفاصيل الوظيفة
// ---------------------------
class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(job.company,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Text(job.location),
                Text(job.salary),
                Text(job.type),
                Text(job.date),
              ],
            ),
            const SizedBox(height: 16),
            Text(job.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              children: job.tags
                  .map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.green.shade50,
              ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text("تقديم الآن"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
