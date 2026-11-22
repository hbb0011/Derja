
import 'package:flutter/material.dart';

import '../widgets/welcome_section.dart';
import '../widgets/search.dart';
import '../widgets/word_card.dart';
import '../widgets/category.dart';
import '../widgets/nav.dart';
import '../data/word_service.dart';
import '../models/word.dart';
import 'dictionary_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late final Future<Word?> wordOfTheDay;
  late final Future<List<Word>> allWords;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    wordOfTheDay = WordService.getWordOfTheDay();
    allWords = WordService.getWords();
  }

  final List<Map<String, dynamic>> situations = [
    {
      'title': 'Greetings',
      'arabic': 'تحية',
      'icon': Icons.chat_outlined,
      'color': const Color(0xFFE9D5AD),
    },
    {
      'title': 'Food',
      'arabic': 'مأكولات',
      'icon': Icons.restaurant,
      'color': const Color(0xFFD9968B),
    },
    {
      'title': 'Transport',
      'arabic': 'نقل',
      'icon': Icons.directions_bus_outlined,
      'color': const Color(0xFFA3C9D4),
    },
    {
      'title': 'Shopping',
      'arabic': 'تسوق',
      'icon': Icons.shopping_bag_outlined,
      'color': const Color(0xFFB5C5A7),
    },
  ];


  void onNavigationTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),

      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

        
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB94C3D),
                      border: Border.all(
                        color: const Color(0xFF171717),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 9),

                  const Text(
                    'DERJA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF171717),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No new notifications'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFCF5),
                      side: const BorderSide(
                        color: Color(0xFF171717),
                        width: 2,
                      ),
                      fixedSize: const Size(43, 43),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

            
              const WelcomeSection(),

              const SizedBox(height: 28),

              
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 28),   

              if (searchQuery.trim().isNotEmpty)
                FutureBuilder<List<Word>>(
                  future: allWords,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final results = snapshot.data!
                        .where((w) => w.matchesQuery(searchQuery))
                        .toList();
                    if (results.isEmpty) {
                      return const Text('No words found. Try another search!');
                    }
                    return Column(
                      children: [
                        for (final word in results) ...[
                          WordCard(
                            word: word,
                            featured: true,
                            onTap: () => showWordDetails(context, word),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  },
                )
              else ...[
                // WORD OF THE DAY TITLE
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Color(0xFFB94C3D), size: 16),
                    SizedBox(width: 7),
                    Text(
                      "TODAY'S PICK",
                      style: TextStyle(
                        color: Color(0xFFB94C3D),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text(
                      'Word of the day',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF171717),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF315B3D),
                        border: Border.all(color: const Color(0xFF171717), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DAY 07',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<Word?>(
                  future: wordOfTheDay,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Could not load words: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('No words available');
                    }
                    final word = snapshot.data!;
                    return WordCard(
                      word: word,
                      featured: true,
                      onTap: () => showWordDetails(context, word),
                    );
                  },
                ),
              ],
              const SizedBox(height: 28),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Explore by situation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF171717),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All situations coming soon!'),
                        ),
                      );
                    },
                    child: const Text(
                      'View all  →',
                      style: TextStyle(
                        color: Color(0xFF315B3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // SITUATION CARDS
              Row(
                children: situations.map((situation) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: SituationCard(
                        title: situation['title'],
                        arabic: situation['arabic'],
                        icon: situation['icon'],
                        color: situation['color'],
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${situation['title']} selected',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // DAILY CHALLENGE / EXTRA SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF315B3D),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to learn more?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Discover new Tunisian words every day!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

         const DictionaryScreen(),
            const FavoritesScreen(),
            const ProfileScreen(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: onNavigationTap,
      ),
    );
  }
}
