import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';

import '../constants/constants.dart';
import '../models/model.dart';

class LabelItemsPage extends StatefulWidget {
  const LabelItemsPage({Key? key}) : super(key: key);

  @override
  _LabelItemsPageState createState() => _LabelItemsPageState();
}

class _LabelItemsPageState extends State<LabelItemsPage> {
  @override
  Widget build(BuildContext context) {
    var settings = ModalRoute.of(context)!.settings.arguments
        as LabelItemPageRouteSettings;

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: AppBar(title: Text(settings.tag.name)),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UnDraw(
                    height: 150.0,
                    illustration: UnDrawIllustration.floating,
                    color: Colors.greenAccent),
                const Text('No items with this label',
                    style: TextStyle(fontSize: 18.0)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Add an item'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LabelItemPageRouteSettings {
  final Tag tag;

  const LabelItemPageRouteSettings({required this.tag});
}
