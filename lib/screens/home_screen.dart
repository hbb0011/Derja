import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_info.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_in_up.dart';
import '../widgets/hard_card.dart';
import '../widgets/search.dart';
import '../widgets/small_widgets.dart';
import '../widgets/word_card.dart';
import '../widgets/words_gate.dart';
import '../providers/reglages_model.dart';

/// Tab 1: Home.
/// Shows: welcome text, search bar, word of the day, category shortcuts.
///
/// The two callbacks let this screen ask the MainScreen to change the tab
/// (Home doesn't know about the bottom bar, it just says "please open X").
class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenDictionary;
  final VoidCallback onOpenProfile;

  const HomeScreen({
    super.key,
    required this.onOpenDictionary,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final sombre = context.watch<ReglagesModel>().sombre;

    return WordsGate(
      builder: (context, words) {
        final wordOfDay = words.wordOfTheDay;
        final day = DateTime.now().day.toString().padLeft(2, '0'); // 07

        // RefreshIndicator = pull down to reload (calls GET again).
        return RefreshIndicator(
          onRefresh: words.loadWords,
          child: ListView(
            // Lets the pull-to-refresh work even if the list is short.
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              // ---- Welcome ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ahlan! Welcome',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1),
                        ),
                        // Text.rich lets us mix styles in one sentence.
                        const Text.rich(
                          TextSpan(
                            text: 'to ',
                            children: [
                              TextSpan(
                                text: 'Tunisia.',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1),
                        ),
                        const SizedBox(height: 8),
                        const Text('Learn to speak like a local.',
                            style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        tooltip: sombre ? 'Switch to light mode' : 'Switch to dark mode',
                        onPressed: () {
                          context.read<ReglagesModel>().basculerTheme();
                        },
                        icon: Icon(
                          sombre ? Icons.light_mode : Icons.dark_mode,
                          size: 28,
                        ),
                      ),
                      const Text('🌶️', style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---- Search: on Enter we jump to the Dictionary ----
              SearchBox(
                hint: 'Search a word or expression...',
                onSubmitted: (text) {
                  words.setFilter(query: text); // category goes back to "All"
                  onOpenDictionary();
                },
              ),
              const SizedBox(height: 24),

              // ---- Word of the day ----
              const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.red),
                  SizedBox(width: 6),
                  SectionLabel("Today's pick", color: AppColors.red),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Word of the day',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('DAY $day',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (wordOfDay != null)
                FadeInUp(child: WordCard(word: wordOfDay)),
              const SizedBox(height: 24),

              // ---- Categories ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Explore by situation',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  TextButton(
                    onPressed: () {
                      words.setFilter(); // no filter = all words
                      onOpenDictionary();
                    },
                    child: const Text('View all →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                // Horizontal list of tiles (one per category).
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final c = kCategories[i];
                    return SizedBox(
                      width: 112,
                      child: HardCard(
                        color: c.color,
                        radius: 16,
                        padding: const EdgeInsets.all(10),
                        onTap: () {
                          words.setFilter(category: c.name);
                          onOpenDictionary();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.paper,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: AppColors.ink, width: 2),
                              ),
                              child: Icon(c.icon, size: 20, color: AppColors.ink),
                            ),
                            const SizedBox(height: 6),
                            Text(c.name,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                            Text(c.arabic,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ---- Bottom card ----
              HardCard(
                color: AppColors.paper,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ready to learn more?',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 4),
                    Text(
                      '${words.all.length} words in the dictionary. '
                      'Know a word that is missing? Add it yourself!',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: onOpenProfile,
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green),
                      icon: const Icon(Icons.add),
                      label: const Text('Add a word'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
