import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/app_theme.dart';
import '../utils/category_icons.dart';

class CategoryCard extends StatelessWidget {
  final TriviaCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyles.getStyle(category.id, category.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppTheme.primary.withOpacity(0.1),
        highlightColor: AppTheme.primary.withOpacity(0.05),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: style.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    style.icon,
                    color: style.iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name.replaceAll('Entertainment: ', '').replaceAll('Science: ', ''),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
