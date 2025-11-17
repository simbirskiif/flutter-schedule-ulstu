import 'package:flutter/material.dart';

class ChillWidget extends StatelessWidget {
  final double maxWidth = 650;
  final double height;
  const ChillWidget({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    Color onBackground = ColorScheme.of(context).onSurface;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Icon(Icons.arrow_upward, color: onBackground),
                    ),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "Text Time",
                        style: TextStyle(color: onBackground),
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: Icon(Icons.arrow_downward, color: onBackground),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

