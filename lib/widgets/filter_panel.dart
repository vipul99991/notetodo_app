import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  final String? selectedFolder;
  final String? selectedTag;
  final bool favoritesOnly;
  final DateTimeRange? dateRange;
  final Function({
    String? folderId,
    String? tag,
    bool? favoritesOnly,
    DateTimeRange? dateRange,
  }) onFilterChanged;

  const FilterPanel({
    super.key,
    this.selectedFolder,
    this.selectedTag,
    this.favoritesOnly = false,
    this.dateRange,
    required this.onFilterChanged,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  bool showPanel = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Filters"),
          trailing: Icon(showPanel ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => showPanel = !showPanel),
        ),
        if (showPanel)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Favorites filter
                SwitchListTile(
                  title: const Text("Show favorites only"),
                  value: widget.favoritesOnly,
                  onChanged: (value) =>
                      widget.onFilterChanged(favoritesOnly: value),
                ),

                // Date range filter
                ListTile(
                  title: const Text("Filter by date range"),
                  subtitle: Text(
                    widget.dateRange == null
                        ? "All dates"
                        : "${widget.dateRange!.start.toString().split(' ')[0]} → ${widget.dateRange!.end.toString().split(' ')[0]}",
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (range != null) widget.onFilterChanged(dateRange: range);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
