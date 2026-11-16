
import 'package:flutter/material.dart';

class SituationCard extends StatelessWidget {
  final String title;
  final String arabic;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SituationCard({
    super.key,
    required this.title,
    required this.arabic,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 102,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: const Color(0xFF171717),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF171717),
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF5),
                border: Border.all(
                  color: const Color(0xFF171717),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                size: 20,
                color: const Color(0xFF171717),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              arabic,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF37332D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
