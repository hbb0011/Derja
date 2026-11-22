import 'package:flutter/material.dart';
import '../data/favorites_service.dart';
import '../data/word_service.dart';
import '../models/word.dart';
import '../widgets/word_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Word>> _words;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _words = WordService.getWords();
    WordService.version.addListener(_reload);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }
  void _reload() {
    setState(() {
      _words = WordService.getWords();
    });
  }

  @override
  void dispose() {
    WordService.version.removeListener(_reload);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E5),

      body: SafeArea(
        child: FutureBuilder<List<Word>>(
          future: _words,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF315B3D),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Could not load words: ${snapshot.error}',
                ),
              );
            }

            final allWords = snapshot.data ?? const <Word>[];

            return ListenableBuilder(
              listenable: FavoritesService.instance,
              builder: (context, _) {
                // All saved words
                final favorites = allWords
                    .where(
                      (w) =>
                          FavoritesService.instance.isFavorite(w.id),
                    )
                    .toList();

                // Only saved words matching the search
                final filteredFavorites = favorites.where((word) {
                  if (_searchQuery.isEmpty) {
                    return true;
                  }

                  final english =
                      word.english.toLowerCase();


                  return english.contains(_searchQuery);
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        16,
                        24,
                        0,
                      ),
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
                                  borderRadius:
                                      BorderRadius.circular(12),
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
                                  color: Color(0xFF171717),
                                ),
                              ),

                              const Spacer(),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBD9B8),
                                  border: Border.all(
                                    color: const Color(0xFF171717),
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'TUNISIAN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                    color: Color(0xFF171717),
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
                            'Favorites',
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF171717),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Keep the words that make your journey easier.',
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
                              borderRadius:
                                  BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF171717),
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Search your saved words...',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF77736B),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF171717),
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                         
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),

                           
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFCF5),
                              border: Border.all(
                                color: const Color(0xFF171717),
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),

                            child: Row(
                              children: [
                              
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBD9B8),
                                    border: Border.all(
                                      color:
                                          const Color(0xFF171717),
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFB94C3D),
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'MY COLLECTION',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.w900,
                                          letterSpacing: 1.2,
                                          color:
                                              Color(0xFF315B3D),
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        '${favorites.length} saved '
                                        '${favorites.length == 1 ? 'expression' : 'expressions'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Color(0xFF171717),
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      const Text(
                                        'Ready for your next conversation.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color(0xFF625D55),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 17),

                         
                          Row(
                            children: [
                              const Text(
                                'Recently saved',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF171717),
                                ),
                              ),

                              const Spacer(),

                              Row(
                                children: const [
                                  Icon(
                                    Icons.tune,
                                    size: 14,
                                    color: Color(0xFF625D55),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Organize',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Color(0xFF625D55),
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    
                    Expanded(
                      child: filteredFavorites.isEmpty
                          ? Center(
                              child: _EmptyState(
                                isSearching:
                                    _searchQuery.isNotEmpty,
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                24,
                                0,
                                24,
                                24,
                              ),
                              itemCount:
                                  filteredFavorites.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder:
                                  (context, index) {
                                final word =
                                    filteredFavorites[index];

                                return WordCard(
                                  word: word,
                                  featured: true,
                                  onTap: () =>
                                      showWordDetails(
                                    context,
                                    word,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSearching;

  const _EmptyState({
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSearching
              ? Icons.search_off
              : Icons.favorite_border,
          size: 44,
          color: const Color(0xFF858078),
        ),

        const SizedBox(height: 12),

        Text(
          isSearching
              ? 'No words found'
              : 'No favorites yet',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF171717),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          isSearching
              ? 'Try another word or meaning.'
              : 'Tap the heart on any word to save it here.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF746B5D),
          ),
        ),
      ],
    );
  }
}
