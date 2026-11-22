
import 'package:flutter/material.dart';

import '../models/word.dart';
import '../widgets/word_card.dart';
import '../data/word_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController searchController =
      TextEditingController();

  late Future<List<Word>> wordsFuture;

  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Greetings',
    'Food',
    'Shopping',
    'Transport',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    wordsFuture = WordService.getWords();
      WordService.version.addListener(_reload);
  }

  void _reload() {
    setState(() {
      wordsFuture = WordService.getWords();
    });
  }

  @override
  void dispose() {
    WordService.version.removeListener(_reload);
    searchController.dispose();
    super.dispose();
  }

  List<Word> filterWords(List<Word> words) {
    return words.where((word) {
      final query = searchQuery.toLowerCase().trim();

      final matchesSearch =
          word.derja.toLowerCase().contains(query) ||
          word.arabic.contains(query) ||
          word.english.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
          word.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB94C3D),
                          border: Border.all(
                            color: const Color(0xFF171717),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'DERJA',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBD9B8),
                          border: Border.all(
                            color: const Color(0xFF171717),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'TUNISIAN',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 27),

                  const Text(
                    'KLEM TUNSI',
                    style: TextStyle(
                      color: Color(0xFFB94C3D),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'The Dictionary.',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF171717),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Discover the words of everyday Tunisia.',
                    style: TextStyle(
                      color: Color(0xFF625D55),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFCF5),
                      border: Border.all(
                        color: const Color(0xFF171717),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF171717),
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search a word or meaning...',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF77736B),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF171717),
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'EXPLORE CATEGORIES',
                    style: TextStyle(
                      color: Color(0xFFB94C3D),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected =
                            selectedCategory == category;

                        return GestureDetector(
                          onTap: () => changeCategory(category),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF315B3D)
                                  : const Color(0xFFFFFCF5),
                              border: Border.all(
                                color: const Color(0xFF171717),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF171717),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

         
            Expanded(
              child: FutureBuilder<List<Word>>(
                future: wordsFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF315B3D),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong loading words.'),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No words available yet.'),
                    );
                  }

                  final filteredWords =
                      filterWords(snapshot.data!);

                  if (filteredWords.isEmpty) {
                    return const Center(
                      child: Text(
                        'No words found. Try another search!',
                        style: TextStyle(
                          color: Color(0xFF625D55),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      24, 5, 24, 25,
                    ),
                    itemCount: filteredWords.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final word = filteredWords[index];

                      return WordCard(
                        word: word,
                        featured: true,
                        onTap: () {
                          showWordDetails(context, word);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /*bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section is coming soon!'),
              ),
            );
          }
        },
      ),*/
    );
  }

  
}
