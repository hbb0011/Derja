
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // WELCOME TEXT - LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MARHBE BIK  مرحبا بيك',
                style: TextStyle(
                  color: Color(0xFFB94C3D),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 31,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF171717),
                  ),
                  children: [
                    TextSpan(text: 'Ahlan! Welcome\n'),
                    TextSpan(text: 'to '),
                    TextSpan(
                      text: 'Tunisia.',
                      style: TextStyle(
                        color: Color(0xFF315B3D),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 9),

              const Text(
                'Learn to speak like a local.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF625D55),
                ),
              ),
            ],
          ),

          // YALLA SPEECH BUBBLE - RIGHT
          Positioned(
            right: 48,
            top: 17,
            child: Transform.rotate(
              angle: -0.12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Yalla!',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // CHILLI - FAR RIGHT
          const Positioned(
            right: 10,
            bottom: -5,
            child: Text(
              '🌶️',
              style: TextStyle(fontSize: 77),
            ),
          ),
        ],
      ),
    );
  }
}
