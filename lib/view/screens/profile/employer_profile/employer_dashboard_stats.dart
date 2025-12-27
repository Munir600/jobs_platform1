import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/config/app_colors.dart';
import '../../../../../controllers/EmployerDashboardController.dart';
import '../../../../../data/models/accounts/profile/employer/employer_dashboard.dart';

class EmployerDashboardStatsScreen extends StatelessWidget {
  const EmployerDashboardStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployerDashboardController(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshStats(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.refreshStats(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final stats = controller.dashboardStats.value;
        if (stats == null) {
          return const Center(child: Text('لا توجد بيانات متاحة'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshStats(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewSection(stats.overview),
                const SizedBox(height: 24),
                if (stats.charts != null) ...[
                  _buildSectionTitle('تحليلات الطلبات'),
                  _buildChartCard(
                    title: 'الطلبات بمرور الوقت',
                    child: _buildBarChart(stats.charts!.appsOverTime),
                  ),
                  _buildChartCard(
                    title: 'حالة الطلبات',
                    child: _buildPieChart(stats.charts!.applicationsByStatus),
                  ),
                   const SizedBox(height: 24),
                  _buildSectionTitle('توزيع الوظائف'),
                  _buildChartCard(
                    title: 'الوظائف حسب المدينة',
                    child: _buildHorizontalBarChart(stats.charts!.jobsByCity),
                  ),
                   _buildChartCard(
                    title: 'الوظائف حسب الفئة',
                    child: _buildHorizontalBarChart(stats.charts!.jobsByCategory),
                  ),
                   _buildChartCard(
                    title: 'الوظائف حسب النوع',
                    child: _buildPieChart(stats.charts!.jobsByType),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('تحليلات المتقدمين'),
                   _buildChartCard(
                    title: 'المتقدمين حسب المدينة',
                    child: _buildHorizontalBarChart(stats.charts!.applicantsByCity),
                  ),
                   _buildChartCard(
                    title: 'المتقدمين حسب الفئة',
                     child: _buildHorizontalBarChart(stats.charts!.applicantsByCategory),
                  ),
                   _buildChartCard(
                    title: 'المتقدمين حسب المسمى الوظيفي',
                     child: _buildHorizontalBarChart(stats.charts!.applicantsByJobTitle),
                  ),

                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOverviewSection(Overview? overview) {
    if (overview == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: [
        _buildStatCard('إجمالي الوظائف', overview.totalJobs, Icons.work, Colors.blue),
        _buildStatCard('الوظائف النشطة', overview.activeJobs, Icons.check_circle, Colors.green),
        _buildStatCard('إجمالي الطلبات', overview.totalApplications, Icons.description, Colors.orange),
        _buildStatCard('متقدمين فريدين', overview.totalUniqueApplicants, Icons.person, Colors.purple),
        _buildStatCard('إجمالي المشاهدات', overview.totalViews, Icons.visibility, Colors.teal),
        _buildStatCard('الرسائل', overview.totalMessages, Icons.message, Colors.indigo, subValue: '${overview.unreadMessages} غير مقروء'),
      ],
    );
  }

  Widget _buildStatCard(String title, int? value, IconData icon, Color color, {String? subValue}) {
    return Card(
      color: AppColors.accentColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value?.toString() ?? '0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
             if (subValue != null)
              Text(
                subValue,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // --- Simple Custom Visualizations ---

  Widget _buildBarChart(ApplicantsByCategory? data) {
    if (data == null || data.labels == null || data.series == null || data.labels!.isEmpty) {
      return const Text('لا توجد بيانات للرسم البياني');
    }

    final maxVal = data.series!.reduce((curr, next) => curr > next ? curr : next);
    // Avoid division by zero
    final max = maxVal > 0 ? maxVal : 1;

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.labels!.length,
        itemBuilder: (context, index) {
          final label = data.labels![index];
          final value = data.series![index];
          final percentage = value / max;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 120 * percentage, // Scale height reduced to fit labels
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                RotatedBox(
                  quarterTurns: 1, // Rotate label if long
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalBarChart(ApplicantsByCategory? data) {
    if (data == null || data.labels == null || data.series == null || data.labels!.isEmpty) {
      return const Text('لا توجد بيانات للرسم البياني');
    }

    final maxVal = data.series!.isEmpty ? 0 : data.series!.reduce((curr, next) => curr > next ? curr : next);
    final max = maxVal > 0 ? maxVal : 1;

    return Column(
      children: List.generate(data.labels!.length, (index) {
        final label = data.labels![index];
        final value = data.series![index];
        var percentage = value / max;
        // Ensure percentage is valid
        percentage = percentage.clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          // Optional: Background track
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // The Bar
                          FractionallySizedBox(
                            widthFactor: percentage,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: _getColor(index),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30, // Fixed width for value to align charts better
                      child: Text(
                        value.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPieChart(ApplicantsByCategory? data) {
    if (data == null || data.labels == null || data.series == null || data.labels!.isEmpty) {
      return const Text('لا توجد بيانات للرسم البياني');
    }

    // Since we don't have a pie chart library, we'll use a legend + progress bar style
    // or a simple colored row. Let's do a stacked bar for "Pie like" visual or just a list with colors.
    
    final total = data.series!.fold(0, (sum, item) => sum + item);
     // Avoid division by zero
    final totalVal = total > 0 ? total : 1;


    return Column(
      children: [
        // Stacked Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: List.generate(data.labels!.length, (index) {
              final value = data.series![index];
              final flex = ((value / totalVal) * 100).toInt();
              if (flex == 0) return const SizedBox.shrink(); // Hide if too small
              
              return Expanded(
                flex: flex,
                child: Container(
                  height: 30,
                  color: _getColor(index),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: List.generate(data.labels!.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: _getColor(index),
                ),
                const SizedBox(width: 4),
                Text('${data.labels![index]} (${data.series![index]})'),
              ],
            );
          }),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    const colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
