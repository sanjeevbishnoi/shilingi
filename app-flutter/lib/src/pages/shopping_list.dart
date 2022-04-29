/// Shopping list shows all shopping list created. A user can interact with them individually
/// in the shopping list detail page
import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shilingi/src/models/model.dart';
import 'package:intl/intl.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../components/components.dart';
import '../constants/constants.dart';
import './select_items.dart' show SelectItemsPage;
import '../gql/gql.dart';
import './shopping_list_detail.dart';

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
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SelectItemsPage(
                        title: 'Create new shopping list')));
              },
            ),
          ],
        ),
        backgroundColor: mainScaffoldBg,
        body: const _Body(),
        bottomNavigationBar: const ClassicBottomNavigation(),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var queryResult = useQuery(
      QueryOptions(
        document: shoppingListQuery,
        variables: const {
          'first': 10,
        },
      ),
    );

    if (queryResult.result.isLoading && queryResult.result.data == null) {
      return const Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (queryResult.result.hasException) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnDraw(
                illustration: UnDrawIllustration.warning,
                color: Colors.redAccent,
                height: 150,
              ),
              const Text('Unable to load shopping list'),
              const SizedBox(height: 4.0),
              TextButton(
                onPressed: () {
                  queryResult.refetch();
                },
                child: const Text('Retry reload'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final connection = ShoppingListConnection.fromJson(
        queryResult.result.data!['shoppingList']);

    if (connection.edges.isEmpty) {
      // TODO(jack): add refresh when a user navigates back from creating the
      // first list
      return const _EmptyList();
    }

    return RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 30.0),
        itemBuilder: (context, index) {
          return _ShoppingList(list: connection.edges[index].node);
        },
        itemCount: connection.edges.length,
      ),
      onRefresh: () {
        return queryResult.refetch();
      },
    );
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
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text:
                        'Plan for your next shopping and checkout your shopping list on the ',
                  ),
                  TextSpan(
                      text: 'GO!', style: TextStyle(color: Colors.black87)),
                ],
              ),
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

class _ShoppingList extends StatelessWidget {
  final ShoppingList list;

  const _ShoppingList({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShoppingListDetail(id: list.id)));
            },
            splashColor: Colors.black45,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                fontSize: 18.0)),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              size: 14.0,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 5.0),
                            Timeago(
                              builder: (_, value) => Tooltip(
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black45),
                                ),
                                message: DateFormat("EEE, MMM d, ''yy'")
                                    .format(list.createTime!.toLocal()),
                              ),
                              date: list.createTime!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
