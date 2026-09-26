import 'package:flutter/material.dart';

class CategoryStyle {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CategoryStyle({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class CategoryStyles {
  static const List<CategoryStyle> _palette = [
    CategoryStyle(
      icon: Icons.lightbulb_outline,
      backgroundColor: Color(0xFFEFF6FF), // Blue
      iconColor: Color(0xFF2563EB),
    ),
    CategoryStyle(
      icon: Icons.menu_book,
      backgroundColor: Color(0xFFFDF2F8), // Pink
      iconColor: Color(0xFFDB2777),
    ),
    CategoryStyle(
      icon: Icons.movie_creation_outlined,
      backgroundColor: Color(0xFFF5F3FF), // Purple
      iconColor: Color(0xFF7C3AED),
    ),
    CategoryStyle(
      icon: Icons.music_note_outlined,
      backgroundColor: Color(0xFFECFDF5), // Green
      iconColor: Color(0xFF059669),
    ),
    CategoryStyle(
      icon: Icons.theater_comedy_outlined,
      backgroundColor: Color(0xFFFFFBEB), // Amber
      iconColor: Color(0xFFD97706),
    ),
    CategoryStyle(
      icon: Icons.tv,
      backgroundColor: Color(0xFFF0FDF4), // Emerald
      iconColor: Color(0xFF16A34A),
    ),
    CategoryStyle(
      icon: Icons.sports_esports_outlined,
      backgroundColor: Color(0xFFEEF2FF), // Indigo
      iconColor: Color(0xFF4F46E5),
    ),
    CategoryStyle(
      icon: Icons.casino_outlined,
      backgroundColor: Color(0xFFFFF1F2), // Rose
      iconColor: Color(0xFFE11D48),
    ),
    CategoryStyle(
      icon: Icons.nature_people_outlined,
      backgroundColor: Color(0xFFF0FDFA), // Teal
      iconColor: Color(0xFF0D9488),
    ),
    CategoryStyle(
      icon: Icons.computer_outlined,
      backgroundColor: Color(0xFFE0F2FE), // Sky
      iconColor: Color(0xFF0284C7),
    ),
    CategoryStyle(
      icon: Icons.calculate_outlined,
      backgroundColor: Color(0xFFFEF3C7), // Yellow
      iconColor: Color(0xFFB45309),
    ),
    CategoryStyle(
      icon: Icons.auto_awesome_outlined,
      backgroundColor: Color(0xFFFDF4FF), // Fuchsia
      iconColor: Color(0xFFC026D3),
    ),
    CategoryStyle(
      icon: Icons.sports_soccer_outlined,
      backgroundColor: Color(0xFFECFCCB), // Lime
      iconColor: Color(0xFF65A30D),
    ),
    CategoryStyle(
      icon: Icons.public,
      backgroundColor: Color(0xFFE0E7FF), // Indigo light
      iconColor: Color(0xFF4338CA),
    ),
    CategoryStyle(
      icon: Icons.history_edu_outlined,
      backgroundColor: Color(0xFFF5EBE0), // Warm beige
      iconColor: Color(0xFF9A7B56),
    ),
    CategoryStyle(
      icon: Icons.gavel_outlined,
      backgroundColor: Color(0xFFF1F5F9), // Slate
      iconColor: Color(0xFF475569),
    ),
    CategoryStyle(
      icon: Icons.palette_outlined,
      backgroundColor: Color(0xFFFEE2E2), // Red light
      iconColor: Color(0xFFDC2626),
    ),
    CategoryStyle(
      icon: Icons.star_outline,
      backgroundColor: Color(0xFFFEF9C3), // Yellow light
      iconColor: Color(0xFFCA8A04),
    ),
    CategoryStyle(
      icon: Icons.pets_outlined,
      backgroundColor: Color(0xFFDCFCE7), // Mint
      iconColor: Color(0xFF15803D),
    ),
    CategoryStyle(
      icon: Icons.directions_car_outlined,
      backgroundColor: Color(0xFFE0F7FA), // Cyan
      iconColor: Color(0xFF00838F),
    ),
  ];

  /// Returns styling based on category name keywords or category id hash
  static CategoryStyle getStyle(int id, String name) {
    final lower = name.toLowerCase();

    if (lower.contains('book')) return _palette[1];
    if (lower.contains('film') || lower.contains('movie')) return _palette[2];
    if (lower.contains('music')) return _palette[3];
    if (lower.contains('theatre') || lower.contains('musical')) return _palette[4];
    if (lower.contains('television') || lower.contains('tv')) return _palette[5];
    if (lower.contains('game')) return _palette[6];
    if (lower.contains('board')) return _palette[7];
    if (lower.contains('nature') || lower.contains('science')) return _palette[8];
    if (lower.contains('computer')) return _palette[9];
    if (lower.contains('math')) return _palette[10];
    if (lower.contains('myth')) return _palette[11];
    if (lower.contains('sport')) return _palette[12];
    if (lower.contains('geography')) return _palette[13];
    if (lower.contains('history')) return _palette[14];
    if (lower.contains('politic')) return _palette[15];
    if (lower.contains('art')) return _palette[16];
    if (lower.contains('celeb')) return _palette[17];
    if (lower.contains('animal')) return _palette[18];
    if (lower.contains('vehicle')) return _palette[19];

    // Fallback: stable index by id
    return _palette[id % _palette.length];
  }
}
