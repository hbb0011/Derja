import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_info.dart';
import '../models/word.dart';
import '../providers/favorites_model.dart';
import '../providers/words_model.dart';
import '../theme/app_colors.dart';
import '../widgets/delete_word.dart';
import '../widgets/hard_card.dart';
import '../widgets/small_widgets.dart';

/// Tab 4: Profile.
///   1. small statistics
///   2. the FORM to add a word            -> POST
///   3. the list to manage words (bin)    -> DELETE
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // The key identifies the form, so we can call validate() on it.
  final _formKey = GlobalKey<FormState>();

  // One controller per text field = lets us READ (and clear) what the user typed.
  final _derjaCtrl = TextEditingController();
  final _arabicCtrl = TextEditingController();
  final _pronunciationCtrl = TextEditingController();
  final _englishCtrl = TextEditingController();
  final _exampleCtrl = TextEditingController();
  final _exampleTrCtrl = TextEditingController();
  final _explanationCtrl = TextEditingController();

  // The two choices made with chips.
  String _category = kCategories.first.name; // 'Greetings'
  String _difficulty = kDifficulties.first; // 'Beginner'

  bool _saving = false; // true while the POST request is running

  @override
  void dispose() {
    _derjaCtrl.dispose();
    _arabicCtrl.dispose();
    _pronunciationCtrl.dispose();
    _englishCtrl.dispose();
    _exampleCtrl.dispose();
    _exampleTrCtrl.dispose();
    _explanationCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ POST
  Future<void> _submit() async {
    // validate() runs every `validator` and shows the red messages.
    if (!_formKey.currentState!.validate()) return;

    // 1. Build a Word from what the user typed (id is empty: the server
    //    will create it).
    final newWord = Word(
      id: '',
      derja: _derjaCtrl.text.trim(),
      arabic: _arabicCtrl.text.trim(),
      pronunciation: _pronunciationCtrl.text.trim(),
      english: _englishCtrl.text.trim(),
      category: _category,
      difficulty: _difficulty,
      explanation: _explanationCtrl.text.trim(),
      example: _exampleCtrl.text.trim(),
      exampleTranslation: _exampleTrCtrl.text.trim(),
    );

    final words = context.read<WordsModel>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true); // disable the button + show spinner

    try {
      // 2. Send it to the server.
      await words.addWord(newWord);

      // 3. It worked: empty the form and say it.
      // (mounted = the user did not leave this tab while we were waiting)
      if (mounted) _clearForm();
      messenger.showSnackBar(
        SnackBar(content: Text('"${newWord.derja}" added to the dictionary ✅')),
      );
    } catch (e) {
      // The server did not answer: the word was NOT saved.
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Could not save: is json-server running?'),
        ),
      );
    }

    if (mounted) setState(() => _saving = false);
  }

  void _clearForm() {
    _derjaCtrl.clear();
    _arabicCtrl.clear();
    _pronunciationCtrl.clear();
    _englishCtrl.clear();
    _exampleCtrl.clear();
    _exampleTrCtrl.clear();
    _explanationCtrl.clear();
    _formKey.currentState?.reset(); // also removes the red error messages
    setState(() {
      _category = kCategories.first.name;
      _difficulty = kDifficulties.first;
    });
  }

  // ------------------------------------------------------- form field helper
  /// One labelled text field. Written once, used 7 times below.
  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool mandatory = false, // is the field mandatory?
    bool rtl = false, // right-to-left (for Arabic)
    int maxLines = 1,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            // The validator returns an error TEXT, or null if all is fine.
            validator: mandatory
                ? (value) => (value == null || value.trim().isEmpty)
                    ? 'This field is required'
                    : null
                : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.muted),
              filled: true,
              fillColor: AppColors.cream,
              border: border(AppColors.ink, 1.5),
              enabledBorder: border(AppColors.ink, 1.5),
              focusedBorder: border(AppColors.green, 2.5),
              errorBorder: border(Colors.red, 1.5),
              focusedErrorBorder: border(Colors.red, 2.5),
            ),
          ),
        ],
      ),
    );
  }

  /// A row of chips to pick ONE option (category or difficulty).
  Widget _chips(
      List<String> options, String selected, ValueChanged<String> onPick) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          AppChoiceChip(
            label: option,
            selected: selected == option,
            onTap: () => onPick(option),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------- screen
  @override
  Widget build(BuildContext context) {
    final words = context.watch<WordsModel>();
    final favoritesCount = context.watch<FavoritesModel>().count;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        // ---- Header ----
        const Row(
          children: [
            AppLogo(),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel('Profile & settings', color: AppColors.muted),
                Text('Your journey',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ---- Stats ----
        Row(
          children: [
            Expanded(child: _stat('${words.all.length}', 'words')),
            const SizedBox(width: 8),
            Expanded(child: _stat('$favoritesCount', 'favorites')),
          ],
        ),
        const SizedBox(height: 20),

        // ---- The form ----
        HardCard(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add a new word',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Fill the boxes, then press the button.',
                    style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 20),
                _field(
                  label: 'Derja (Latin letters)',
                  hint: 'Aslema',
                  controller: _derjaCtrl,
                  mandatory: true,
                ),
                _field(
                  label: 'Arabic',
                  hint: 'عسلامة',
                  controller: _arabicCtrl,
                  mandatory: true,
                  rtl: true,
                ),
                _field(
                  label: 'Pronunciation',
                  hint: 'As-le-ma',
                  controller: _pronunciationCtrl,
                ),
                _field(
                  label: 'English meaning',
                  hint: 'Hello',
                  controller: _englishCtrl,
                  mandatory: true,
                ),
                const SectionLabel('Category'),
                const SizedBox(height: 8),
                _chips(
                  kCategories.map((c) => c.name).toList(),
                  _category,
                  (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 16),
                const SectionLabel('Difficulty'),
                const SizedBox(height: 8),
                _chips(
                  kDifficulties,
                  _difficulty,
                  (value) => setState(() => _difficulty = value),
                ),
                const SizedBox(height: 16),
                _field(
                  label: 'Explanation',
                  hint: 'When and how do we use this word?',
                  controller: _explanationCtrl,
                  maxLines: 3,
                ),
                _field(
                  label: 'Example sentence',
                  hint: 'Aslema, chnowa a7welek?',
                  controller: _exampleCtrl,
                ),
                _field(
                  label: 'Example translation',
                  hint: 'Hello, how are you?',
                  controller: _exampleTrCtrl,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    // onPressed: null disables the button while saving.
                    onPressed: _saving ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.add),
                    label: Text(_saving ? 'Saving...' : 'Add the word'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // ---- Manage words (DELETE) ----
        const SectionLabel('Manage words', color: AppColors.red),
        const SizedBox(height: 4),
        const Text('Press the bin to delete a word from the database.',
            style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 12),
        HardCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              if (words.all.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No words loaded.'),
                ),
              // .reversed = newest first, so a word you just added is on top.
              for (final w in words.all.reversed)
                ListTile(
                  key: ValueKey(w.id),
                  contentPadding: EdgeInsets.zero,
                  title: Text(w.derja,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${w.english}  •  ${w.category}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => confirmAndDeleteWord(context, w),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// A small statistic box ("56 words").
  Widget _stat(String number, String label) {
    return HardCard(
      color: AppColors.sand,
      child: Column(
        children: [
          Text(number,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
