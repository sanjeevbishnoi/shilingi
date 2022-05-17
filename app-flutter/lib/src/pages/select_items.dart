/// Allows a user to select a set of items to add to an existing list e.g Shopping list
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:intl/intl.dart';

import '../gql/gql.dart';
import '../constants/constants.dart';
import '../models/model.dart';
import '../components/components.dart';

typedef ItemsSelected = Function(List<int>);

class SelectItemsPage extends HookWidget {
  final String title;
  final String buttonString;
  final bool resultsOnPop;

  const SelectItemsPage(
      {Key? key,
      required this.title,
      required this.buttonString,
      this.resultsOnPop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemsResult = useState<List<Item>>([]);
    var tags = useState<List<Tag>>([]);
    var selectedTags = useState<Set<Tag>>({});
    var queryResult = useQuery(QueryOptions(
        document: itemsQueryWithLabels,
        fetchPolicy: FetchPolicy.cacheAndNetwork));
    var selectedItems = useState<List<int>>([]);
    var result = queryResult.result;
    var createButtonPosition = useState<double>(-50.0);
    var showButton = useState<bool>(false);
    final searchString = useState<String>('');
    var showSelected = useState<bool>(false);

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
      itemsResult.value = _filterItems(
          items: items.items,
          selected: selectedItems.value,
          showSelected: showSelected.value,
          searchString: searchString.value,
          tags: selectedTags.value);
      Set<Tag> _tags = {};
      items.items.forEach((item) {
        _tags.addAll(item.tags!);
      });
      tags.value = _tags.toList(growable: false);

      body = Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchCategorySelect(
                text: searchString.value,
                categories: tags.value,
                onChanged: (value) {
                  searchString.value = value;
                },
                onTagSelected: (tag) {
                  final tags = selectedTags.value.toSet();
                  tags.add(tag);
                  selectedTags.value = tags;
                }),
            const SizedBox(height: 20.0),
            Row(
              children: [
                _SelectButton(
                    onPressed: () {
                      showSelected.value = false;
                    },
                    text: 'All',
                    selected: !showSelected.value),
                const SizedBox(width: 5.0),
                _SelectButton(
                    onPressed: () {
                      showSelected.value = true;
                    },
                    text: 'Selected',
                    selected: showSelected.value),
              ],
            ),
            if (selectedTags.value.isNotEmpty) ...[
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 2.0,
                runSpacing: 0.0,
                children: [
                  for (var tag in selectedTags.value)
                    Chip(
                      label: Text(tag.name),
                      onDeleted: () {
                        final tags = selectedTags.value.toSet();
                        tags.remove(tag);
                        selectedTags.value = tags;
                      },
                    ),
                ],
              ),
            ],
            const SizedBox(height: 10.0),
            Expanded(
              child: Stack(
                children: [
                  if (itemsResult.value.isNotEmpty)
                    CustomAZListView(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 20.0),
                      data: itemsResult.value,
                      hash: selectedItems.value.length,
                      children: [
                        for (var item in itemsResult.value)
                          _Item(
                              item: item,
                              onTap: () {
                                selectedItems.value.contains(item.id)
                                    ? selectedItems.value.remove(item.id)
                                    : selectedItems.value.add(item.id!);
                                selectedItems.notifyListeners();
                              },
                              selected: selectedItems.value.contains(item.id)),
                      ],
                    ),
                  if (itemsResult.value.isEmpty && showSelected.value)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Text('No items match',
                          style: TextStyle(color: Colors.black54)),
                    ),
                  if (itemsResult.value.isEmpty && !showSelected.value)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _EmptySearchResult(
                        searchString: searchString.value,
                        onCreate: () async {
                          final result = await queryResult.refetch();
                          if (result != null && result.data != null) {
                            var items = Items.fromJson(result.data!);
                            itemsResult.value = _filterItems(
                                items: items.items,
                                selected: selectedItems.value,
                                showSelected: showSelected.value,
                                searchString: searchString.value,
                                tags: selectedTags.value);
                            // Only one item will be visible at this point, so we can
                            // safely add it to the selected list
                            if (itemsResult.value.length == 1) {
                              selectedItems.value.add(itemsResult.value[0].id!);
                              selectedItems.notifyListeners();
                            }
                          }
                        },
                      ),
                    ),
                  if (showButton.value)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      bottom: createButtonPosition.value,
                      left: 0,
                      right: 0,
                      child: Builder(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: () {
                              if (!resultsOnPop) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return _SetTitleModal(
                                        selectedItems: selectedItems.value,
                                      );
                                    });
                              } else {
                                Navigator.of(context).pop(selectedItems.value);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(buttonString),
                                const SizedBox(width: 5.0),
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreenAccent,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                        selectedItems.value.length.toString()),
                                  ),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: AppBar(
            title: Text(title),
            backgroundColor: mainScaffoldBg,
            centerTitle: true),
        body: body,
      ),
    );
  }

  List<Item> _filterItems(
      {required List<Item> items,
      required List<int> selected,
      required bool showSelected,
      required String searchString,
      Set<Tag>? tags}) {
    Iterable<Item> results = items;

    if (tags != null && tags.isNotEmpty) {
      results = results
          .where((item) => item.tags!.isNotEmpty)
          .where((item) => tags.contains(item.tags![0]));
    }

    if (showSelected) {
      results = results.where((item) => selected.contains(item.id));
    }

    if (searchString.isEmpty) {
      return results.toList();
    }

    return results
        .where((item) =>
            item.name.toLowerCase().contains(searchString.toLowerCase()))
        .toList();
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
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Item not found.'),
          const SizedBox(width: 5.0),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.lightGreen),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            onPressed: () {
              saving.value = true;
              _createItem(context, onCreate);
            },
            child: Text('Create $searchString',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
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
      child: Text(text),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: selected
                ? const BorderSide(color: Colors.lightGreen)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(20.0),
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

// class _LabelPopup extends StatelessWidget {
// final List<String> categories;
//
// }

class _SearchCategorySelect extends HookWidget {
  final String text;
  final List<Tag> categories;
  final ValueChanged<String> onChanged;
  final ValueChanged<Tag> onTagSelected;

  const _SearchCategorySelect(
      {Key? key,
      required this.text,
      required this.categories,
      required this.onChanged,
      required this.onTagSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Container(
      height: 40.0,
      padding: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          if (text.isNotEmpty)
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: IconButton(
                  iconSize: 14.0,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.text = "";
                    onChanged("");
                  },
                ),
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: text.isEmpty ? 14 : 0),
              ),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const VerticalDivider(color: Colors.grey),
          PopupMenuButton<Tag>(
            onSelected: onTagSelected,
            itemBuilder: (context) => [
              for (var c in categories)
                PopupMenuItem<Tag>(
                  child: Text(c.name),
                  value: c,
                ),
            ],
            child: const Icon(Icons.arrow_drop_down),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
          )
        ],
      ),
    );
  }
}

class _SetTitleModal extends HookWidget {
  final List<int> selectedItems;

  const _SetTitleModal({Key? key, required this.selectedItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = useState<String>(
        'Shopping ' + DateFormat('EEE h:ma, MMM d').format(DateTime.now()));
    var loading = useState<bool>(false);
    var controller = useTextEditingController();
    useEffect(() {
      controller.text = text.value;
      return;
    }, [text]);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: mainScaffoldBg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                width: 30.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20.0),
                child: TextField(
                  controller: controller,
                  onChanged: (val) {
                    text.value = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide
                          .none, // const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .grey), // const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    isDense: true,
                    hintText: 'e.g Monthly shopping',
                    labelText: 'Type a title',
                    labelStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 14.0),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: text.value.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              text.value = "";
                              controller.clear();
                            },
                            icon: const Icon(Icons.clear))
                        : null,
                  ),
                  enabled: !loading.value,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: text.value.isNotEmpty && !loading.value
                    ? () async {
                        loading.value = true;
                        var result =
                            await _createList(context, controller.text);
                        if (result.hasException) {
                          var snackBar = const SnackBar(
                              content: Text(
                                  'Unable to create shopping list. Retry later'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        var snackBar = const SnackBar(
                            content:
                                Text('Shopping list created successfully'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/shopping-list'));
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 5.0),
                    Text(loading.value ? 'Creating...' : 'Create new list'),
                  ],
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double?>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<QueryResult> _createList(BuildContext context, String title) async {
    final cli = GraphQLProvider.of(context).value;
    var result = await cli.mutate(
      MutationOptions(
        document: mutationCreateShoppingList,
        variables: {
          'input': {
            'name': title,
            'items': [
              for (var id in selectedItems) {'item': id}
            ]
          },
        },
      ),
    );
    return result;
  }
}
