import 'package:flutter/material.dart';

@immutable
class SelectableCard extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool? isCompact;
  const SelectableCard({
    super.key,
    required this.title,
    required this.isSelected,
    this.isCompact,
  });

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: widget.isSelected
            ? ColorScheme.of(context).primary
            : ColorScheme.of(context).surfaceVariant,
        borderRadius: widget.isSelected
            ? BorderRadius.circular(35)
            : BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: !(widget.isCompact ?? false) ? 16 : 16,
          vertical: !(widget.isCompact ?? false) ? 16 : 8,
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.isSelected
                ? ColorScheme.of(context).onPrimary
                : ColorScheme.of(context).onSurface,
          ),
        ),
      ),
    );
  }
}
