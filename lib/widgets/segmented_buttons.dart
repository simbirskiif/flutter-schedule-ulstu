import 'package:flutter/widgets.dart';
import 'package:timetable/widgets/selectable_card.dart';

class SegmentedButtons extends StatefulWidget {
  final List<String> items;
  final int? initialIndex;
  final ValueChanged<int>? onSelected;
  const SegmentedButtons({
    super.key,
    required this.items,
    this.initialIndex,
    this.onSelected,
  });

  @override
  State<SegmentedButtons> createState() => _SegmentedButtonsState();
}

class _SegmentedButtonsState extends State<SegmentedButtons> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items.asMap().entries.map((entry) {
        int index = entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelected?.call(_selectedIndex);
              },
              child: SelectableCard(
                title: entry.value,
                isSelected: index == _selectedIndex,
                isCompact: true,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
