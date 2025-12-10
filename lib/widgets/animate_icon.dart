import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimateIcon extends StatelessWidget {
  const AnimateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icon.svg",
      color: ColorScheme.of(context).secondaryContainer,
      width: 240 * 1.2,
      height: 108 * 1.2,
    );
  }
}
