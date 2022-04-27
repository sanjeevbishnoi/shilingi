/// Allows a user to select a set of items to add to an existing list e.g Shopping list
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../gql/gql.dart';
import '../constants/constants.dart';
import '../models/model.dart';

class SelectItemsPage extends HookWidget {
  final String title;
  const SelectItemsPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemsResult = useState<List<Item>>([]);
    var queryResult = useQuery(QueryOptions(document: itemsQuery));
    var selectedItems = useState<List<int>>([]);
    var result = queryResult.result;
    var createButtonPosition = useState<double>(-50.0);
    var showButton = useState<bool>(false);
    final searchString = useState<String>('');

    if (selectedItems.value.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 0), () {
        showButton.value = true;
      });
      Future.delayed(const Duration(milliseconds: 20), () {
        createButtonPosition.value = 0;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 10), () {
        createButtonPosition.value = -50.0;
        Future.delayed(const Duration(milliseconds: 300), () {
          showButton.value = false;
        });
      });
    }

    Widget body;
    if (result.isLoading && result.data == null) {
      body = const Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (result.hasException) {
      body = Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UnDraw(
                  illustration: UnDrawIllustration.warning,
                  color: Colors.redAccent,
                  height: 150.0),
              const Text('Unable to load items')
            ],
          ),
        ),
      );
    } else {
      var items = Items.fromJson(result.data!);
      itemsResult.value = items.items
          .where((item) => item.name
              .toLowerCase()
              .contains(searchString.value.toLowerCase()))
          .toList();

      body = Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                searchString.value = value;
              },
              decoration: InputDecoration(
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 30.0, minHeight: 30.0),
                suffixIcon: const Icon(Icons.search),
                hintText: 'Search',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20.0),
            if (itemsResult.value.isNotEmpty)
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      itemBuilder: (context, index) {
                        final item = itemsResult.value[index];
                        return _Item(
                          item: item,
                          onTap: () {
                            selectedItems.value.contains(item.id)
                                ? selectedItems.value.remove(item.id)
                                : selectedItems.value.add(item.id!);
                            selectedItems.notifyListeners();
                          },
                          selected: selectedItems.value.contains(item.id),
                        );
                      },
                      itemCount: itemsResult.value.length,
                    ),
                    if (showButton.value)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        bottom: createButtonPosition.value,
                        left: 0,
                        right: 0,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                              'Create list (${selectedItems.value.length})'),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            if (itemsResult.value.isEmpty)
              _EmptySearchResult(
                searchString: searchString.value,
                onCreate: () async {
                  final result = await queryResult.refetch();
                  if (result != null && result.data != null) {
                    var items = Items.fromJson(result.data!);
                    itemsResult.value = items.items
                        .where((item) => item.name
                            .toLowerCase()
                            .contains(searchString.value.toLowerCase()))
                        .toList();
                    // Only one item will be visible at this point, so we can
                    // safely add it to the selected list
                    if (itemsResult.value.length == 1) {
                      selectedItems.value.add(itemsResult.value[0].id!);
                      selectedItems.notifyListeners();
                    }
                  }
                },
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(
          title: Text(title),
          backgroundColor: mainScaffoldBg,
          centerTitle: true),
      body: body,
    );
  }
}

class _Item extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final bool selected;

  const _Item(
      {Key? key,
      required this.item,
      required this.onTap,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(0xFFF0F0F0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.add_box,
                  size: 20.0,
                  color: selected ? Colors.lightGreen : Colors.grey,
                ),
              ),
              const SizedBox(width: 5.0),
              Text(item.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchResult extends HookWidget {
  final String searchString;
  final VoidCallback onCreate;

  const _EmptySearchResult(
      {Key? key, required this.searchString, required this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saving = useState<bool>(false);

    if (saving.value) {
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: const TextStyle(color: Colors.black54),
          children: [
            const TextSpan(text: 'Creating '),
            TextSpan(
                text: searchString,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black)),
            const TextSpan(text: '...'),
          ],
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          saving.value = true;
          _createItem(context, onCreate);
        },
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(
                  text: 'Item not found. ',
                  style: TextStyle(color: Colors.black54)),
              TextSpan(
                  text: 'Create $searchString',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  void _createItem(BuildContext context, VoidCallback callback) {
    var cli = GraphQLProvider.of(context).value;
    cli
        .mutate(
      MutationOptions(document: mutationCreateItem, variables: {
        "input": {
          "name": searchString,
        }
      }),
    )
        .then((result) {
      if (!result.hasException) {
        callback();
      } else {
        const snackBar =
            SnackBar(content: Text('Unable to create item, try again later'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
