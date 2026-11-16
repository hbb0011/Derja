import 'package:flutter/material.dart';
import '../data/favorites_service.dart';
import '../models/word.dart';
import 'favorite_button.dart';

const Color _ink = Color(0xFF171717);
const Color _cream = Color(0xFFFFFCF5);
const Color _sand = Color(0xFFEBD9B8);
const Color _green = Color(0xFF315B3D);
const Color _red = Color(0xFFC94F43);
const Color _sheetBg = Color(0xFFF7F1E5);

class WordCard extends StatelessWidget {
  final Word word;
  final bool featured;
  final VoidCallback? onTap;

  const WordCard({
    super.key,
    required this.word,
    this.featured = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final meanings = word.english.split(' / ');
    final primaryMeaning = meanings.first;
    final otherMeanings = meanings.skip(1).join(' / ');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: _sand,
          border: Border.all(color: _ink, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color:_ink,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  word.arabic,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(width: 14), // gap between the text and the buttons
 Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Audio feature coming soon!'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 18,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: _green,
                        side: const BorderSide(color: _ink, width: 2),
                        fixedSize: const Size(38, 38),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FavoriteButton(wordId: word.id, size: 38),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              word.derja,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: _green,
              ),
            ),
            const SizedBox(height: 18),
            Container(height: 1.5, color: const Color(0xFFB7A78B)),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: primaryMeaning,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: _ink,
                          ),
                        ),
                        if (otherMeanings.isNotEmpty)
                          TextSpan(
                            text: ' / $otherMeanings',
                            style: const TextStyle(color: Color(0xFF746B5D)),
                          ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                if (featured)
                  IconButton(
                    onPressed: onTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Word details coming soon!'),
                            ),
                          );
                        },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: _ink,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: _cream,
                border: Border.all(color: _ink, width: 1.5),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                word.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// WORD DETAILS SHEET (same function name, so nothing else changes)
// ===========================================================================
void showWordDetails(BuildContext context, Word word) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WordDetailsSheet(word: word),
  );
}

typedef _U = double Function(double);

class _WordDetailsSheet extends StatelessWidget {
  final Word word;

  const _WordDetailsSheet({required this.word});

  @override
  Widget build(BuildContext context) {
    // The design was drawn for a ~248px wide screen. Everything is scaled
    // from that so it looks the same on every phone.
    final width = MediaQuery.of(context).size.width;
    final s = (width / 248).clamp(1.0, 1.6).toDouble();
    double u(double v) => v * s;

    const french = '';
    const culture = '';
    return Container(
      padding: EdgeInsets.fromLTRB(u(20), u(10), u(20), u(18)),
      decoration: BoxDecoration(
        color: _sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(u(28))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, u),
              SizedBox(height: u(12)),
              _heroCard(context, u),
              SizedBox(height: u(12)),
              _meaningCard(u, french),
              SizedBox(height: u(10)),
              _exampleCard(context, u),
              if (culture.isNotEmpty) ...[
                SizedBox(height: u(10)),
                _cultureCard(u, culture),
              ],
              SizedBox(height: u(10)),
              _SaveToFavoritesButton(wordId: word.id, scale: s),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HEADER: back arrow + WORD DETAILS / Expression
  // -------------------------------------------------------------------------
  Widget _header(BuildContext context, _U u) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: u(24),
            height: u(24),
            decoration: BoxDecoration(
              color: _cream,
              shape: BoxShape.circle,
              border: Border.all(color: _ink, width: u(1.6)),
            ),
            child: Icon(Icons.arrow_back, size: u(13), color: _ink),
          ),
        ),
        SizedBox(width: u(8)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WORD DETAILS',
              style: TextStyle(
                fontSize: u(6.5),
                fontWeight: FontWeight.w900,
                color: _green,
                letterSpacing: u(0.8),
              ),
            ),
            Text(
              'Expression',
              style: TextStyle(
                fontSize: u(19),
                fontWeight: FontWeight.w900,
                color: _ink,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // BIG ARCH CARD: icon, arabic, derja, Listen
  // -------------------------------------------------------------------------
  Widget _heroCard(BuildContext context, _U u) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(u(16), u(14), u(16), u(14)),
      decoration: BoxDecoration(
        color: _sand,
        border: Border.all(color: _ink, width: u(1.8)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(u(60)),
          topRight: Radius.circular(u(60)),
          bottomLeft: Radius.circular(u(12)),
          bottomRight: Radius.circular(u(12)),
        ),
        boxShadow: [BoxShadow(color: _ink, offset: Offset(u(3), u(4)))],
      ),
      child: Column(
        children: [
          _archIcon(u),
          SizedBox(height: u(6)),
          Text(
            word.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: u(28),
              fontWeight: FontWeight.w900,
              color: _ink,
              height: 1.2,
            ),
          ),
          Text(
            word.derja,
            style: TextStyle(
              fontSize: u(8.5),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: _green,
            ),
          ),
          SizedBox(height: u(8)),
          _listenButton(context, u),
        ],
      ),
    );
  }

  // Small house / arch illustration (outline arch, sun, blue door)
  Widget _archIcon(_U u) {
    return Container(
      width: u(34),
      height: u(44),
      decoration: BoxDecoration(
        color: _cream,
        border: Border.all(color: _ink, width: u(1.8)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(u(17)),
          topRight: Radius.circular(u(17)),
          bottomLeft: Radius.circular(u(2)),
          bottomRight: Radius.circular(u(2)),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // terracotta sun
          Positioned(
            top: u(6),
            left: u(8),
            right: u(8),
            child: Container(
              height: u(13),
              decoration: BoxDecoration(
                color: const Color(0xFFD9743F),
                border: Border.all(color: _ink, width: u(1.2)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(u(8)),
                  topRight: Radius.circular(u(8)),
                ),
              ),
            ),
          ),
          // blue door
          Container(
            width: u(13),
            height: u(21),
            decoration: BoxDecoration(
              color: const Color(0xFF4C86B8),
              border: Border.all(color: _ink, width: u(1.4)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(u(7)),
                topRight: Radius.circular(u(7)),
              ),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: u(2)),
            child: Container(
              width: u(2),
              height: u(2),
              decoration: const BoxDecoration(
                color: _cream,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listenButton(BuildContext context, _U u) {
    return Container(
      decoration: BoxDecoration(
        color: _green,
        border: Border.all(color: _ink, width: u(1.4)),
        borderRadius: BorderRadius.circular(u(7)),
        boxShadow: [BoxShadow(color: _ink, offset: Offset(0, u(2)))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(u(7)),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Audio feature coming soon!')),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: u(13), vertical: u(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up, size: u(11), color: Colors.white),
                SizedBox(width: u(4)),
                Text(
                  'Listen',
                  style: TextStyle(
                    fontSize: u(7.5),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // 01 MEANING
  // -------------------------------------------------------------------------
  Widget _meaningCard(_U u, String french) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(u(11), u(10), u(11), u(2)),
      decoration: BoxDecoration(
        color: _cream,
        border: Border.all(color: _ink, width: u(1.4)),
        borderRadius: BorderRadius.circular(u(10)),
        boxShadow: [BoxShadow(color: _ink, offset: Offset(u(2), u(3)))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '01 · MEANING',
            style: TextStyle(
              fontSize: u(6),
              fontWeight: FontWeight.w900,
              color: _green,
              letterSpacing: u(0.9),
            ),
          ),
          SizedBox(height: u(7)),
          _divider(u),
          _languageRow(u, 'EN', 'English', word.english),
          if (french.isNotEmpty) ...[
            _divider(u),
            _languageRow(u, 'FR', 'Français', french),
          ],
        ],
      ),
    );
  }

  Widget _divider(_U u) {
    return Container(height: u(1), color: const Color(0xFFE6DCC6));
  }

  Widget _languageRow(_U u, String badge, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: u(7)),
      child: Row(
        children: [
          Container(
            width: u(22),
            height: u(22),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _sand,
              border: Border.all(color: _ink, width: u(1)),
              borderRadius: BorderRadius.circular(u(5)),
            ),
            child: Text(
              badge,
              style: TextStyle(fontSize: u(6), fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(width: u(9)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: u(6),
                    color: const Color(0xFF8A847A),
                  ),
                ),
                SizedBox(height: u(1)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: u(11),
                    fontWeight: FontWeight.w900,
                    color: _ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // 02 USE IT LIKE A LOCAL
  // -------------------------------------------------------------------------
  Widget _exampleCard(BuildContext context, _U u) {
    final example = word.example.isNotEmpty ? word.example : word.derja;
    final arabic = word.arabic;
    final translation = word.exampleTranslation.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(u(11)),
      decoration: BoxDecoration(
        color: _green,
        border: Border.all(color: _ink, width: u(1.4)),
        borderRadius: BorderRadius.circular(u(10)),
        boxShadow: [BoxShadow(color: _ink, offset: Offset(u(2), u(3)))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '02 · USE IT LIKE A LOCAL',
            style: TextStyle(
              fontSize: u(6),
              fontWeight: FontWeight.w900,
              color: _sand,
              letterSpacing: u(0.9),
            ),
          ),
          SizedBox(height: u(8)),
                    SizedBox(
            width: double.infinity,
            child: Text(
              arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: u(15),
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: u(3)),
          Text(
            example,
            style: TextStyle(
              fontSize: u(9),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          SizedBox(height: u(7)),
          Container(height: u(1), color: Colors.white24),
          SizedBox(height: u(7)),
          Row(
            children: [
              Expanded(
                child: Text(
                  translation.isEmpty ? '' : '“$translation”',
                  style: TextStyle(
                    fontSize: u(7),
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(width: u(8)),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Audio feature coming soon!')),
                  );
                },
                child: Container(
                  width: u(18),
                  height: u(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.volume_up, size: u(10), color: _green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // A LITTLE CULTURE (dashed border)
  // -------------------------------------------------------------------------
  Widget _cultureCard(_U u, String culture) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: const Color(0xFF7CA9A8),
        radius: u(8),
        strokeWidth: u(1.2),
        dash: u(4),
        gap: u(3),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(u(10)),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF3F2),
          borderRadius: BorderRadius.circular(u(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.nightlight_round,
              size: u(12),
              color: const Color(0xFF9DB9C8),
            ),
            SizedBox(width: u(7)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A little culture',
                    style: TextStyle(
                      fontSize: u(6.5),
                      fontWeight: FontWeight.w900,
                      color: _ink,
                    ),
                  ),
                  SizedBox(height: u(2)),
                  Text(
                    culture,
                    style: TextStyle(
                      fontSize: u(6),
                      color: const Color(0xFF4F6B68),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SAVE TO FAVORITES BUTTON (works with FavoritesService)
// ===========================================================================
class _SaveToFavoritesButton extends StatelessWidget {
  final int wordId;
  final double scale;

  const _SaveToFavoritesButton({required this.wordId, required this.scale});

  @override
  Widget build(BuildContext context) {
    double u(double v) => v * scale;

    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final saved = FavoritesService.instance.isFavorite(wordId);
        final radius = BorderRadius.circular(u(8));

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          decoration: BoxDecoration(
            color: saved ? _cream : _red,
            border: Border.all(color: _ink, width: u(1.4)),
            borderRadius: radius,
            boxShadow: [BoxShadow(color: _ink, offset: Offset(0, u(3)))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              onTap: () => FavoritesService.instance.toggle(wordId),
              child: SizedBox(
                height: u(28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: u(12),
                      color: saved ? _red : Colors.white,
                    ),
                    SizedBox(width: u(5)),
                    Text(
                      saved ? 'Saved · tap to remove' : 'Save to favorites',
                      style: TextStyle(
                        fontSize: u(7.5),
                        fontWeight: FontWeight.w900,
                        color: saved ? _ink : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===========================================================================
// Dashed rounded border (Flutter has no built-in dashed border)
// ===========================================================================
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dash != dash ||
      old.gap != gap;
}