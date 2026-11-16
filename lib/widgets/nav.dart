
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const Color green = Color(0xFF315B3D);
  static const Color black = Color(0xFF171717);

  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  final List<String> labels = const [
    'Home',
    'Dictionary',
    'Favorites',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFCF5),
        border: Border(
          top: BorderSide(
            color: Color(0xFF171717),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(4, (index) {
            final bool isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 39,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(
                                color: black,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        icons[index],
                        size: 22,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF858078),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w500,
                        color: isSelected
                            ? black
                            : const Color(0xFF858078),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
