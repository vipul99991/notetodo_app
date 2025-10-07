import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: note.isPinned ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
                child: Text(note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            if (note.isPinned)
              const Icon(Icons.push_pin, size: 18, color: Colors.amber),
          ],
        ),
        subtitle:
            Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'pin') onPin();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'pin',
              child: Text(note.isPinned ? 'Unpin' : 'Pin'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Move to Trash'),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
