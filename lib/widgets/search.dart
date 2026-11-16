
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        border: Border.all(
          color: const Color(0xFF171717),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF171717),
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Search a word or expression...',
          hintStyle: TextStyle(
            fontSize: 13,
            color: Color(0xFF77736B),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF171717),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }
}
