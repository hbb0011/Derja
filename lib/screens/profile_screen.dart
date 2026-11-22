import 'package:flutter/material.dart';
import '../data/word_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: const [
        _ProfileHeader(),
        SizedBox(height: 24),
        _AddWordForm(),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFC94F43),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF171717), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xFF171717), offset: Offset(2, 3)),
            ],
          ),
          child: const Icon(Icons.translate, color: Colors.white, size: 22),
        ),

        const SizedBox(width: 12),

        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'PROFILE & SETTINGS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Color(0xFF315B3D),
              ),
            ),
            Text(
              'Your journey',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF171717),
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//The form card
class _AddWordForm extends StatefulWidget {
  const _AddWordForm();

  @override
  State<_AddWordForm> createState() => _AddWordFormState();
}

class _AddWordFormState extends State<_AddWordForm> {
  // One "notebook" per box. Each one remembers what you typed in its box.
  final derjaController = TextEditingController();
  final arabicController = TextEditingController();
  final pronunciationController = TextEditingController();
  final englishController = TextEditingController();
  final categoryController = TextEditingController();
  final difficultyController = TextEditingController();
  final exampleController = TextEditingController();
  final exampleTranslationController = TextEditingController();

  // When this page is destroyed, throw the notebooks away.
  @override
  void dispose() {
    derjaController.dispose();
    arabicController.dispose();
    pronunciationController.dispose();
    englishController.dispose();
    categoryController.dispose();
    difficultyController.dispose();
    exampleController.dispose();
    exampleTranslationController.dispose();
    super.dispose();
  }

    Future<void> saveWord() async {
    final derja = derjaController.text.trim();
    final arabic = arabicController.text.trim();
    final english = englishController.text.trim();

    // These three boxes are required
    if (derja.isEmpty || arabic.isEmpty || english.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill at least: Derja, Arabic and English.'),
        ),
      );
      return;
    }

    await WordService.addWord(
      derja: derja,
      arabic: arabic,
      english: english,
      pronunciation: pronunciationController.text.trim(),
      category: categoryController.text.trim().isEmpty
          ? 'My words'
          : categoryController.text.trim(),
      difficulty: difficultyController.text.trim().isEmpty
          ? 'Beginner'
          : difficultyController.text.trim(),
      example: exampleController.text.trim(),
      exampleTranslation: exampleTranslationController.text.trim(),
    );

    // the page may have closed while we were waiting
    if (!mounted) return;

    // empty all the boxes
    derjaController.clear();
    arabicController.clear();
    pronunciationController.clear();
    englishController.clear();
    categoryController.clear();
    difficultyController.clear();
    exampleController.clear();
    exampleTranslationController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Word added!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        border: Border.all(color: const Color(0xFF171717), width: 2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0xFF171717), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add a new word',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF171717),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fill the boxes, then press the button.',
            style: TextStyle(fontSize: 12, color: Color(0xFF746B5D)),
          ),
          const SizedBox(height: 18),

          _FormField(
            label: 'Derja (Latin letters)',
            hint: 'Aslema',
            controller: derjaController,
          ),
          _FormField(
            label: 'Arabic',
            hint: 'عسلامة',
            controller: arabicController,
            textDirection: TextDirection.rtl,
          ),
          _FormField(
            label: 'Pronunciation',
            hint: 'As-le-ma',
            controller: pronunciationController,
          ),
          _FormField(
            label: 'English meaning',
            hint: 'Hello',
            controller: englishController,
          ),
          _FormField(
            label: 'Category',
            hint: 'Greetings',
            controller: categoryController,
          ),
          _FormField(
            label: 'Difficulty',
            hint: 'Beginner',
            controller: difficultyController,
          ),
          _FormField(
            label: 'Example sentence',
            hint: 'Aslema, chnowa a7welek?',
            controller: exampleController,
          ),
          _FormField(
            label: 'Example translation',
            hint: 'Hello, how are you?',
            controller: exampleTranslationController,
          ),

          const SizedBox(height: 4),

          // The button. It does nothing yet (Step 3 will wake it up).
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF315B3D),
              border: Border.all(color: const Color(0xFF171717), width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0xFF171717), offset: Offset(0, 3)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: saveWord,
                child: const SizedBox(
                  height: 46,
                  child: Center(
                    child: Text(
                      'Add word',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//label + text field 
class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextDirection? textDirection;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: Color(0xFF315B3D),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            textDirection: textDirection,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF171717),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFB0A793),
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F1E5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF171717),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF315B3D),
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}