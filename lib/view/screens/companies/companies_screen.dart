import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({Key? key}) : super(key: key);

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // بيانات تجريبية للشركات
  final List<Map<String, dynamic>> companiesData = [
    {
      "id": "tech-solutions",
      "name": "شركة التقنيات المتقدمة",
      "industry": "تقنية المعلومات",
      "location": "صنعاء",
      "logo": "assets/images/Logo4.png",
      "description": "شركة رائدة في مجال تطوير البرمجيات وحلول تقنية المعلومات.",
      "employees": 150,
      "openJobs": 5,
      "followers": 1200,
      "tags": ["تطوير البرمجيات", "تصميم المواقع", "تطبيقات الجوال"],
      "size": "متوسطة",
      "featured": true,
    },
    {
      "id": "health-care",
      "name": "مستشفى الأمل",
      "industry": "الرعاية الصحية",
      "location": "عدن",
      "logo": "assets/images/Logo4.png",
      "description": "مستشفى متخصص يقدم خدمات طبية شاملة.",
      "employees": 300,
      "openJobs": 8,
      "followers": 850,
      "tags": ["طب عام", "جراحة", "تمريض"],
      "size": "كبيرة",
      "featured": true,
    },
    {
      "id": "education-center",
      "name": "مركز التعليم الحديث",
      "industry": "التعليم",
      "location": "تعز",
      "logo": "assets/images/Logo4.png",
      "description": "مركز تعليمي متطور يقدم برامج تدريبية متنوعة.",
      "employees": 80,
      "openJobs": 3,
      "followers": 650,
      "tags": ["تعليم", "تدريب", "تطوير المهارات"],
      "size": "صغيرة",
      "featured": true,
    },
  ];

  List<Map<String, dynamic>> filteredCompanies = [];

  // قيم الفلاتر
  String? selectedIndustry;
  String? selectedLocation;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    filteredCompanies = companiesData;
  }

  void applyFilters() {
    setState(() {
      filteredCompanies = companiesData.where((company) {
        final industryOk = selectedIndustry == null || selectedIndustry == "الكل" || company["industry"] == selectedIndustry;
        final locationOk = selectedLocation == null || selectedLocation == "الكل" || company["location"] == selectedLocation;
        final sizeOk = selectedSize == null || selectedSize == "الكل" || company["size"] == selectedSize;

        return industryOk && locationOk && sizeOk;
      }).toList();
    });
  }

  void searchCompanies(String query) {
    setState(() {
      filteredCompanies = companiesData.where((company) {
        final name = company["name"].toString().toLowerCase();
        final industry = company["industry"].toString().toLowerCase();
        final desc = company["description"].toString().toLowerCase();
        return (name.contains(query.toLowerCase()) ||
            industry.contains(query.toLowerCase()) ||
            desc.contains(query.toLowerCase()));
      }).toList();
    });
  }

  Widget buildCompanyCard(Map<String, dynamic> company) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // التنقل لصفحة تفاصيل الشركة
          print("عرض الشركة: ${company['id']}");
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(company["logo"]),
                  radius: 35,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(company["industry"],
                          style: TextStyle(color: Colors.grey[600])),
                      Text("📍 ${company["location"]}",
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(company["description"],
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: List.generate(company["tags"].length, (i) {
                return Chip(
                  label: Text(company["tags"][i]),
                  backgroundColor: Colors.blue.shade50,
                );
              }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text("${company["employees"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("موظف"),
                ]),
                Column(children: [
                  Text("${company["openJobs"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("وظائف"),
                ]),
                Column(children: [
                  Text("${company["followers"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("متابع"),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      print("متابعة الشركة: ${company['id']}");
                    },
                    child: const Text("متابعة"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print("عرض الوظائف للشركة: ${company['id']}");
                    },
                    child: const Text("عرض الوظائف"),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget buildFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "القطاع", border: OutlineInputBorder()),
                value: selectedIndustry,
                items: ["الكل", "تقنية المعلومات", "الرعاية الصحية", "التعليم"]
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedIndustry = value;
                  });
                  applyFilters();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "الموقع", border: OutlineInputBorder()),
                value: selectedLocation,
                items: ["الكل", "صنعاء", "عدن", "تعز"]
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                  applyFilters();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
              labelText: "حجم الشركة", border: OutlineInputBorder()),
          value: selectedSize,
          items: ["الكل", "صغيرة", "متوسطة", "كبيرة"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedSize = value;
            });
            applyFilters();
          },
        ),
      ],
    );
  }

  Widget buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.grey.shade100,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 3,
        children: const [
          _StatItem(number: "250+", label: "شركة مسجلة"),
          _StatItem(number: "1,500+", label: "وظيفة متاحة"),
          _StatItem(number: "15", label: "قطاع مختلف"),
          _StatItem(number: "8", label: "محافظة"),
        ],
      ),
    );
  }

  Widget buildFeaturedCompanies() {
    final featured = companiesData.where((c) => c["featured"] == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الشركات المميزة",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: featured.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final company = featured[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  print("عرض الشركة المميزة: ${company['id']}");
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(company["logo"]),
                        radius: 25,
                      ),
                      const SizedBox(height: 8),
                      Text(company["name"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text("${company["openJobs"]} وظائف",
                          style: TextStyle(color: Colors.blue.shade700)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text("اكتشف أفضل الشركات"),
          backgroundColor: Colors.blue.shade700,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              // البحث
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "ابحث عن الشركات...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: searchCompanies,
              ),
              const SizedBox(height: 20),

              // الفلاتر
              buildFilters(),
              const SizedBox(height: 20),

              // الإحصائيات
              buildStatsSection(),
              const SizedBox(height: 20),

              // الشركات المميزة
              buildFeaturedCompanies(),
              const SizedBox(height: 20),

              // قائمة الشركات
              Column(
                children: List.generate(
                  filteredCompanies.length,
                      (index) => buildCompanyCard(filteredCompanies[index]),
                ),
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
          },
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(number,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
