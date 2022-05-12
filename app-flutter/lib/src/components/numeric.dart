import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SpinBox extends HookWidget {
  final int initial;

  const SpinBox({Key? key, this.initial = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialValue = useState<int>(initial < 1 ? 1 : initial);
    final controller = useTextEditingController();
    controller.text = initial.toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircularButton(
              onPressed: () {
                final text = controller.text;
                if (text.isEmpty) {
                  controller.text = '1';
                } else {
                  var val = (double.tryParse(text) ?? 0) - 1;
                  val = val < 1 ? 1 : val;
                  controller.text = val.toInt().toString();
                }
              },
              icon: Icons.remove),
          const SizedBox(width: 5.0),
          SizedBox(
            width: 50,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              // onChanged: (val) {},
            ),
          ),
          const SizedBox(width: 5.0),
          _CircularButton(
              onPressed: () {
                final text = controller.text;
                if (text.isEmpty) {
                  controller.text = '1';
                } else {
                  controller.text =
                      ((double.tryParse(text) ?? 0) + 1).toInt().toString();
                }
              },
              icon: Icons.add),
        ],
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const _CircularButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color(0xFFefefef),
            shape: CircleBorder(),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
