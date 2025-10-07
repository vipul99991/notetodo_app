import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TagChip(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
        labelStyle:
            TextStyle(color: isSelected ? Colors.white : Colors.black87),
      ),
    );
  }
}
