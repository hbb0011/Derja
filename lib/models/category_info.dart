import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Extra info (icon, colour, Arabic name) for each category.
/// The database only stores the category NAME ("Food"),
/// the app decides how a category LOOKS.
class CategoryInfo {
  final String name;
  final String arabic;
  final IconData icon;
  final Color color;

  const CategoryInfo({
    required this.name,
    required this.arabic,
    required this.icon,
    required this.color,
  });
}

/// The list of categories used by the home tiles, the filter chips
/// and the "Add a new word" form.
const List<CategoryInfo> kCategories = [
  CategoryInfo(
    name: 'Greetings',
    arabic: 'تحية',
    icon: Icons.chat_bubble_outline,
    color: AppColors.sand,
    
  ),
  CategoryInfo(
    name: 'Food',
    arabic: 'مأكولات',
    icon: Icons.restaurant,
    color: Color(0xFFD99A8E),
  ),
  CategoryInfo(
    name: 'Transport',
    arabic: 'نقل',
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF9CC5D3),
  ),
  CategoryInfo(
    name: 'Shopping',
    arabic: 'تسوق',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFB5C4A5),
  ),
  CategoryInfo(
    name: 'General',
    arabic: 'عام',
    icon: Icons.lightbulb_outline,
    color: Color(0xFFCDBFE0),
  ),
];

/// Difficulty levels (used in the form).
const List<String> kDifficulties = ['Beginner', 'Intermediate', 'Advanced'];
