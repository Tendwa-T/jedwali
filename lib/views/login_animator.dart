import 'package:Jedwali/configs/constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';

class ImageAnimator extends StatefulWidget {
  const ImageAnimator({super.key});

  @override
  State<ImageAnimator> createState() => _ImageAnimatorState();
}

class _ImageAnimatorState extends State<ImageAnimator>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastEaseInToSlowEaseOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: appWhite,
          image: DecorationImage(
            image: _getSVGImage('assets/images/loginPage.svg'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

ImageProvider _getSVGImage(String assetName) {
  return Svg(assetName);
}
