import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(