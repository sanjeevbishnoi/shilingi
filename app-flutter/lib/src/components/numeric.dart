import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../pages/shopping_list_helpers/change_notifiers.dart';

class SpinBox extends HookWidget {
  const SpinBox({Key? key, this.initial = 1, this.onChanged}) : super(key: key);

  final int initial;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    controller.text = initial.toString();
    controller.addListener(
      () {
        var units = 1;
        if (controller.text.isNotEmpty) {
          var val = double.tryParse(controller.text);
          units = val?.toInt() ?? 1;
        }

        if (onChanged != null) {
          onChanged!(units);
        } else {
          Provider.of<ShoppingListItemChangeNotifier>(context, listen: false)
              .units = units;
        }
      },
    );

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
