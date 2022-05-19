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
import '../models/hive.dart' as store;

class ShoppingListPage extends HookWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping lists'),
          backgroundColor: mainScaffoldBg,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                queryResult.refetch();
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SelectItemsPage(
                        title: 'Create new shopping list',
                        buttonString: 'Create new list')));
                queryResult.refetch();
              },
            ),
          ],
        ),
        backgroundColor: mainScaffoldBg,
        body: _Body(
          refetch: queryResult.refetch,
          result: queryResult.result,
        ),
        bottomNavigationBar: const ClassicBottomNavigation(),
      ),
    );
  }
}

class _Body extends HookWidget {
  final Refetch refetch;
  final QueryResult result;

  const _Body({Key? key, required this.refetch, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading && result.data == null) {
      return const Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (result.hasException) {
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
                  refetch();
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

    final connection =
        ShoppingListConnection.fromJson(result.data!['shoppingList']);

    if (connection.edges.isEmpty) {
      return _EmptyList(refetch: refetch);
    }

    return RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 30.0),
        itemBuilder: (context, index) {
          return _ShoppingList(
            list: connection.edges[index].node,
            onDelete: () {
              refetch();
            },
          );
        },
        itemCount: connection.edges.length,
      ),
      onRefresh: () {
        return refetch();
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  final Refetch refetch;

  const _EmptyList({Key? key, required this.refetch}) : super(key: key);

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
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SelectItemsPage(
                        title: 'Create new shopping list',
                        buttonString: 'Create new list')));
                refetch();
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
  final VoidCallback? onDelete;

  const _ShoppingList({Key? key, required this.list, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Dismissible(
        key: ValueKey(list.id),
        confirmDismiss: (direction) async {
          var result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.redAccent),
                      SizedBox(width: 5.0),
                      Text('Delete list'),
                    ],
                  ),
                  content:
                      const Text('Are you sure? This action cannot be undone'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.grey))),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Yes, delete'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                        elevation: MaterialStateProperty.all<double>(0.0),
                      ),
                    ),
                  ],
                );
              });
          if (result is bool && result) {
            _deletelist(context);
          }
          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(children: const [
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 30.0),
              child: Icon(Icons.delete),
            ),
            SizedBox(width: 10.0),
            Text('Delete', style: TextStyle(fontSize: 16.0)),
          ]),
        ),
        direction: DismissDirection.startToEnd,
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
              onTap: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShoppingListDetail(id: list.id)));
                // If result is true, we will need to reload the list
                if (result is bool && result && onDelete != null) {
                  onDelete!();
                }
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
                                    'Created $value',
                                    style:
                                        const TextStyle(color: Colors.black45),
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
      ),
    );
  }

  void _deletelist(BuildContext context) async {
    var cli = GraphQLProvider.of(context).value;
    var result = await cli.mutate(
        MutationOptions(document: mutationDeleteShoppingList, variables: {
      'id': list.id,
    }));
    SnackBar snackBar;
    if (result.hasException) {
      final msg = result.exception!.graphqlErrors[0].message;
      snackBar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      );
    } else {
      snackBar =
          const SnackBar(content: Text('List has been successfully deleted'));
      onDelete?.call();
      // Delete from hive store
      store.ShoppingList(id: list.id).clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
