import 'package:flutter/material.dart';

class TabBarIndicator extends Decoration {
  const TabBarIndicator() : super();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _SolidIndicatorPainter(onChanged: onChanged);
  }
}

class _SolidIndicatorPainter extends BoxPainter {
  const _SolidIndicatorPainter({required VoidCallback? onChanged})
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final paint = Paint();
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
    var rect = offset & configuration.size!;
  }
}
