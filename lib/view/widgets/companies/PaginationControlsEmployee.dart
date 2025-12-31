import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class PaginationControlsEmployee extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const PaginationControlsEmployee({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [

            // _buildNavigationButton(
            //   label: 'السابق',
            //   icon: Icons.chevron_right,
            //   onPressed: currentPage > 1 && !isLoading
            //       ? () => onPageChanged(currentPage - 1)
            //       : null,
            // ),
            const SizedBox(width: 8),


            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildPageNumbers(),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Next button (Fixed)
            // _buildNavigationButton(
            //   label: 'التالي',
            //   icon: Icons.chevron_left,
            //   onPressed: currentPage < totalPages && !isLoading
            //       ? () => onPageChanged(currentPage + 1)
            //       : null,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? AppColors.primaryColor : Colors.grey[300],
        foregroundColor: onPressed != null ? Colors.white : Colors.grey[600],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: onPressed != null ? 2 : 0,
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageButtons = [];

    if (totalPages <= 7) {
      // Show all pages if total is 7 or less
      for (int i = 1; i <= totalPages; i++) {
        pageButtons.add(_buildPageButton(i));
        if (i < totalPages) {
          pageButtons.add(const SizedBox(width: 4));
        }
      }
    } else {
      // Show smart pagination with ellipsis
      if (currentPage <= 3) {
        // Near start: 1 2 3 4 ... totalPages
        for (int i = 1; i <= 4; i++) {
          pageButtons.add(_buildPageButton(i));
          pageButtons.add(const SizedBox(width: 4));
        }
        pageButtons.add(_buildEllipsis());
        pageButtons.add(const SizedBox(width: 4));
        pageButtons.add(_buildPageButton(totalPages));
      } else if (currentPage >= totalPages - 2) {
        // Near end: 1 ... (totalPages-3) (totalPages-2) (totalPages-1) totalPages
        pageButtons.add(_buildPageButton(1));
        pageButtons.add(const SizedBox(width: 4));
        pageButtons.add(_buildEllipsis());
        pageButtons.add(const SizedBox(width: 4));
        for (int i = totalPages - 3; i <= totalPages; i++) {
          pageButtons.add(_buildPageButton(i));
          if (i < totalPages) {
            pageButtons.add(const SizedBox(width: 4));
          }
        }
      } else {
        // Middle: 1 ... (current-1) current (current+1) ... totalPages
        pageButtons.add(_buildPageButton(1));
        pageButtons.add(const SizedBox(width: 4));
        pageButtons.add(_buildEllipsis());
        pageButtons.add(const SizedBox(width: 4));
        for (int i = currentPage - 1; i <= currentPage + 1; i++) {
          pageButtons.add(_buildPageButton(i));
          pageButtons.add(const SizedBox(width: 4));
        }
        pageButtons.add(_buildEllipsis());
        pageButtons.add(const SizedBox(width: 4));
        pageButtons.add(_buildPageButton(totalPages));
      }
    }

    return pageButtons;
  }

  Widget _buildPageButton(int pageNumber) {
    final isCurrentPage = pageNumber == currentPage;

    return InkWell(
      onTap: isLoading || isCurrentPage ? null : () => onPageChanged(pageNumber),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isCurrentPage ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isCurrentPage ? AppColors.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isCurrentPage
              ? [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$pageNumber',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.w500,
            color: isCurrentPage ? Colors.white : AppColors.textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return const SizedBox(
      width: 36,
      height: 36,
      child: Center(
        child: Text(
          '...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
