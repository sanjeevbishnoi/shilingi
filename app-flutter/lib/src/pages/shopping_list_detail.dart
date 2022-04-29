import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../gql/gql.dart';
import '../models/model.dart';

class ShoppingListDetail extends HookWidget {
  final int id;

  const ShoppingListDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedItems = useState<List<int>>([]);
    var queryResult = useQuery(
      QueryOptions(document: shoppingDetailQuery, variables: {
        'id': id,
      }),
    );
    var result = queryResult.result;

    ShoppingList? list;
    Widget body;

    if (result.isLoading && result.data == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (result.hasException) {
      body = Padding(
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
              const Text('Unable to load shopping details'),
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
    } else {
      list = ShoppingList.fromJson(result.data!['node']);

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(list.name + ' (${list.items!.length})',
                style: const TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
            child: Text(
                'Last modified: ' +
                    DateFormat("EEE, MMM d, ''yy'").format(
                      list.updateTime!.toLocal(),
                    ),
                style: const TextStyle(color: Colors.black45)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
            child: Wrap(
              spacing: 4.0,
              children: [
                _SelectButton(selected: true, text: 'All', onPressed: () {}),
                _SelectButton(
                    selected: false, text: 'Completed', onPressed: () {}),
                _SelectButton(
                    selected: false, text: 'Uncompleted', onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                itemBuilder: (context, index) {
                  final item = list!.items![index];
                  return _Item(
                    item: item,
                    selected: selectedItems.value.contains(item.id),
                    onChanged: (val) {
                      if (val != null) {
                        final list = selectedItems.value.toList();
                        if (val) {
                          list.add(item.id);
                        } else {
                          list.remove(item.id);
                        }
                        selectedItems.value = list;
                      }
                    },
                  );
                },
                itemCount: list.items!.length),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: mainScaffoldBg, actions: [
          _ShoppingListPopupButton(list: list),
        ]),
        backgroundColor: mainScaffoldBg,
        body: body,
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onPressed;

  const _SelectButton(
      {Key? key,
      required this.selected,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text,
          style: selected
              ? const TextStyle(color: Colors.lightGreen)
              : const TextStyle(color: Colors.black87)),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: selected
                ? const BorderSide(color: Colors.lightGreen)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // minimumSize:
        // MaterialStateProperty.all<Size?>(const Size.fromHeight(20.0)),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final ShoppingListItem item;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const _Item(
      {Key? key,
      required this.item,
      required this.selected,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onChanged(!selected);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Checkbox(
              value: selected,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(width: 5.0),
            Text(item.item.name),
          ],
        ),
      ),
    );
  }
}

enum _ShoppingListPopupActions {
  delete,
}

class _ShoppingListPopupButton extends StatelessWidget {
  final ShoppingList? list;

  const _ShoppingListPopupButton({Key? key, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ShoppingListPopupActions>(
      onSelected: (value) async {
        switch (value) {
          case _ShoppingListPopupActions.delete:
            var result = await _onDelete(context);
            if (result is bool && result) {
              var snackBar = const SnackBar(
                  content: Text('The list has been successfully deleted'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop(true);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        if (list != null)
          PopupMenuItem<_ShoppingListPopupActions>(
            child: Row(
              children: const [
                Icon(Icons.delete, color: Colors.redAccent),
                SizedBox(width: 5.0),
                Text('Delete')
              ],
            ),
            value: _ShoppingListPopupActions.delete,
          ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Future _onDelete(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var deleting = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.redAccent),
                  SizedBox(width: 5.0),
                  Text('Delete list'),
                ],
              ),
              content: const Text('Are you sure?'),
              actions: [
                TextButton(
                    onPressed: deleting
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.grey))),
                ElevatedButton.icon(
                  onPressed: deleting
                      ? null
                      : () async {
                          setState(() {
                            deleting = true;
                          });
                          var cli = GraphQLProvider.of(context).value;
                          var result = await cli.mutate(MutationOptions(
                              document: mutationDeleteShoppingList,
                              variables: {
                                'id': list!.id,
                              }));
                          if (!result.hasException) {
                            Navigator.of(context).pop(true);
                            return;
                          }
                          // Show user error
                          var errMessage =
                              result.exception?.graphqlErrors[0].message ?? "";
                          if (errMessage.isNotEmpty) {
                            var snackBar = SnackBar(
                              content: Text(errMessage),
                              backgroundColor: Colors.redAccent,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          Navigator.of(context).pop(false);
                        },
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(deleting ? 'Deleting...' : 'Yes, delete'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            );
          });
        },
        barrierDismissible: false,
        useSafeArea: true);
  }
}
