import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const FilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: selectedTag == tag,
                    onSelected: (_) => onTagSelected(tag),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                return GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color == Colors.transparent ? Colors.grey[300] : color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(width: 2, color: Colors.black)
                          : null,
                    ),
                    child: color == Colors.transparent ? const Icon(Icons.format_color_reset, size: 18) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}