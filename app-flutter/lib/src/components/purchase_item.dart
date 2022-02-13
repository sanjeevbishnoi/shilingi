import 'package:flutter/material.dart';

import '../models/model.dart' as models;
import './text.dart';

class WPurchaseItem extends StatelessWidget {
  final models.PurchaseItem item;

  const WPurchaseItem({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      child: Row(
        children: [
          ListTitleText(
            item.item!.name,
          ),
        ],
      ),
    );
  }
}
