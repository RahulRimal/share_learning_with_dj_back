import 'package:flutter/material.dart';

import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';

class LoadingHelper {
  static showTextLoading(String text) {
    return LoadingText(text: text);
  }
}

class LoadingText extends StatefulWidget {
  const LoadingText({required this.text});
  final String text;

  @override
  _LoadingTextState createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      // )..repeat(reverse: true);
    )..repeat();

    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // 'Loading',
              widget.text,
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s18,
              ),
            ),
            SizedBox(width: 8),
            Opacity(
              opacity: _animation1.value,
              child: Text(
                '.',
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s18,
                ),
              ),
            ),
            Opacity(
              opacity: _animation2.value,
              child: Text(
                '.',
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s18,
                ),
              ),
            ),
            Opacity(
              opacity: _animation3.value,
              child: Text(
                '.',
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
