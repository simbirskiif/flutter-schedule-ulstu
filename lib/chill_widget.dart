import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChillWidget extends StatelessWidget {
  final double maxWidth = 650;
  final double height;
  const ChillWidget({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
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
                      child: Icon(Icons.arrow_upward),
                    ),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text("Text Time"),
                    ),
                    Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: Icon(Icons.arrow_downward),
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

class Colors {}
