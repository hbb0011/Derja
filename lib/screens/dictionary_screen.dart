import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_info.dart';
import '../providers/words_model.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/search.dart';
import '../widgets/small_widgets.dart';
import '../widgets/word_card.dart';
import '../widgets/words_gate.dart';

/// Tab 2: the full dictionary with live search + category filter.
/// StatefulWidget because the search bar needs a TextEditingController
/// (an object that controls the text inside a text field).
class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    // Start with the text already in the model (the Home screen may have set it).
    _searchCtrl = TextEditingController(text: context.read<WordsModel>().query);
  }

  @override
  void dispose() {
    _searchCtrl.dispose(); // always free controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The chips: "All" + the name of each category.
    final chips = ['All', ...kCategories.map((c) => c.name)];

    return WordsGate(
      builder: (context, words) {
        final results = words.filtered; // words after search + category

        return RefreshIndicator(
          onRefresh: words.loadWords,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              // ---- Header ----
              const Row(
                children: [
                  AppLogo(icon: Icons.menu_book),
                  SizedBox(width: 12),
                  Text('DERJA',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 20),
              const SectionLabel('Klem Tunsi', color: AppColors.red),
              const SizedBox(height: 4),
              const Text('The Dictionary.',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Discover the words of everyday Tunisia.',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 16),

              // ---- Search (filters at every letter) ----
              SearchBox(
                hint: 'Search a word or meaning...',
                controller: _searchCtrl,
                onChanged: words.setQuery,
              ),
              const SizedBox(height: 20),

              // ---- Category chips ----
              const SectionLabel('Explore categories', color: AppColors.red),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final name in chips)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AppChoiceChip(
                          label: name,
                          selected: words.category == name,
                          onTap: () => words.setCategory(name),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('${results.length} words',
                  style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 12),

              // ---- Results ----
              if (results.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('No word found. Try another search.',
                        style: TextStyle(color: AppColors.muted)),
                  ),
                ),

              // `for` inside a list: one card per word.
              // asMap().entries gives us the position (index) of each word,
              // used by FadeInUp to delay the animation a little.
              for (final entry in results.asMap().entries)
                Padding(
                  // The key helps Flutter recognise each card when the
                  // list changes (search / delete).
                  key: ValueKey(entry.value.id),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FadeInUp(
                    index: entry.key,
                    child: WordCard(word: entry.value),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
