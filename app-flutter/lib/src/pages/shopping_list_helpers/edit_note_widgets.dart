import 'package:flutter/material.dart';

class EditNoteCornerDecoration extends BoxDecoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return EditNoteCornerPainting();
  }
}

class EditNoteCornerPainting extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) return;

    final size = configuration.size!;
    final rect = offset & size;

    canvas.drawPath(
        _getPath(rect),
        Paint()
          ..color = Colors.greenAccent
          ..style = PaintingStyle.fill);
  }

  Path _getPath(Rect rect) {
    final path = Path()
      ..moveTo(rect.left, rect.top)
      ..quadraticBezierTo(rect.left + 10, rect.top + 10, rect.left + 8,
          rect.top + rect.height * .50)
      ..quadraticBezierTo(
          rect.left, rect.bottom, rect.left + rect.width * 0.5, rect.bottom - 8)
      ..quadraticBezierTo(
          rect.right - 5, rect.bottom - 14, rect.right, rect.bottom)
      ..lineTo(rect.right, rect.top + 8)
      ..quadraticBezierTo(rect.right, rect.top, rect.right - 8, rect.top)
      ..close();
    // ..close();

    return path;
  }
}
