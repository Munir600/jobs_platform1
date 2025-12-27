import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class CompactStatisticsBar extends StatelessWidget {
  final List<StatisticItem> items;
  final VoidCallback? onShowDetails;

  const CompactStatisticsBar({
    super.key,
    required this.items,
    this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withAlpha(20),
            AppColors.primaryColor.withAlpha(70),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withAlpha(70),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Row(
                children: [
                  _buildStatItem(item),
                  if (index < items.length - 1)
                    Container(
                      height: 20,
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      color: AppColors.primaryColor.withAlpha(70),
                    ),
                ],
              );
            }).toList(),
            
            // Show details button
            if (onShowDetails != null) ...[
              Container(
                height: 20,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.primaryColor.withAlpha(70),
              ),
              InkWell(
                onTap: onShowDetails,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'المزيد',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(StatisticItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: item.color.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.icon,
            size: 16,
            color: item.color,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item.value}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: item.color,
              ),
            ),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textColor.withAlpha(200),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatisticItem {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const StatisticItem({
    required this.icon,
    required this.value,
    required this.label,
    this.color = AppColors.primaryColor,
  });
}
