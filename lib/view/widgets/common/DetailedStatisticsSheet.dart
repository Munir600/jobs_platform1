import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';

class DetailedStatisticsSheet extends StatelessWidget {
  final String title;
  final List<StatCategory> categories;

  const DetailedStatisticsSheet({
    super.key,
    required this.title,
    required this.categories,
  });

  static void show(BuildContext context, {
    required String title,
    required List<StatCategory> categories,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailedStatisticsSheet(
        title: title,
        categories: categories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildCategory(categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(StatCategory category) {
    final total = category.items.fold<int>(
      0,
      (sum, item) => sum + item.value,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              category.icon,
              size: 18,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              category.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'إجمالي: $total',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...category.items.map((item) => _buildStatItem(item, total)),
      ],
    );
  }

  Widget _buildStatItem(StatItem item, int total) {
    final percentage = total > 0 ? (item.value / total * 100) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.value}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: item.color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${percentage.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCategory {
  final String title;
  final IconData icon;
  final List<StatItem> items;

  const StatCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class StatItem {
  final String label;
  final int value;
  final Color color;

  const StatItem({
    required this.label,
    required this.value,
    this.color = AppColors.primaryColor,
  });
}
