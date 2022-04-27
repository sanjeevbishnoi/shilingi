/// Shopping list shows all shopping list created. A user can interact with them individually
/// in the shopping list detail page
import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';

import '../components/components.dart';
import '../constants/constants.dart';
import './select_items.dart' show SelectItemsPage;

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping lists'),
          backgroundColor: mainScaffoldBg,
          centerTitle: true,
        ),
        backgroundColor: mainScaffoldBg,
        body: const _Body(),
        bottomNavigationBar: const ClassicBottomNavigation(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _EmptyList();
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UnDraw(
              height: 150.0,
              illustration: UnDrawIllustration.empty_cart,
              color: Colors.lightGreen,
            ),
            const Text('No shopping list created yet.',
                style: TextStyle(fontSize: 16.0)),
            const Text(
              'A shopping list allows you to plan for your next shopping. It also allows you to create a purchase more easily while on the go.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SelectItemsPage(
                        title: 'Create new shopping list')));
              },
              child: const Text('Create first list'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ))),
            ),
          ],
        ),
      ),
    );
  }
}
