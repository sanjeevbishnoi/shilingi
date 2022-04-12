/// Defines the page that shows sub-labels of a specific label and the
/// Items that are under each sub-label
import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/model.dart';
import '../gql/gql.dart';
import './shopping_item.dart';
import './settings/settings.dart';

class LabelSubLabelsPages extends StatefulWidget {
  final Tag tag;
  const LabelSubLabelsPages({Key? key, required this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LabelSubLabelsPages();
  }
}

class _LabelSubLabelsPages extends State<LabelSubLabelsPages> {
  final List<int> _expanded = [];

  @override
  Widget build(BuildContext context) {
    Refetch? _refetch;

    Future _refresh() {
      if (_refetch != null) {
        return _refetch!();
      }
      return Future.value();
    }

    return Scaffold(
      appBar:
          AppBar(title: Text('Sub-labels for ${widget.tag.name}'), actions: [
        IconButton(
          onPressed: () {
            _addLabel(context).then((value) {
              if (_refetch != null) {
                _refetch!();
              }
            });
          },
          icon: const Icon(Icons.new_label),
        ),
      ]),
      body: Query(
        options: QueryOptions(document: labelItems, variables: {
          'labelID': widget.tag.id,
        }),
        builder: (QueryResult result,
            {FetchMore? fetchMore, Refetch? refetch}) {
          _refetch = refetch;
          if (result.hasException) {
            return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UnDraw(
                        height: 150.0,
                        illustration: UnDrawIllustration.warning,
                        color: Colors.redAccent),
                    const Text('Unable to load items'),
                    if (refetch != null)
                      TextButton(
                        onPressed: refetch,
                        child: const Text('Retry'),
                      ),
                  ],
                ));
          } else if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var label = Tag.fromJson(result.data!['node']);

          if ((label.children ?? []).isEmpty) {
            return _EmptyLabelList(
              tag: widget.tag,
              addCallback: () {
                _addLabel(context);
              },
            );
          }

          var labeledItems = <Item>[];
          label.children!
              .forEach((element) => labeledItems.addAll(element.items!));

          return RefreshIndicator(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ExpansionPanelList(
                  expansionCallback: (index, isExpanded) {
                    setState(() {
                      if (isExpanded) {
                        _expanded.remove(label.children![index].id!);
                      } else {
                        _expanded.add(label.children![index].id!);
                      }
                    });
                  },
                  children: [
                    for (var child in label.children!)
                      ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return _SubLabelEntry(
                            label: child,
                            tag: widget.tag,
                            labeledItems: labeledItems,
                            onItemAdded: _refresh,
                          );
                        },
                        body: Column(
                          // shrinkWrap: true,
                          children: [
                            for (var item in child.items!)
                              _ItemEntry(
                                  item: item, label: child, onDelete: _refresh),
                          ],
                        ),
                        isExpanded: _expanded.contains(child.id),
                      ),
                  ],
                ),
              ),
              onRefresh: () {
                if (refetch != null) {
                  return refetch();
                }
                return Future.value(null);
              });
        },
      ),
    );
  }

  Future _addLabel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => _NewLabelDialog(tag: widget.tag),
    );
  }
}

class _EmptyLabelList extends StatelessWidget {
  final Tag tag;
  final VoidCallback addCallback;

  const _EmptyLabelList(
      {Key? key, required this.tag, required this.addCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UnDraw(
                height: 150,
                illustration: UnDrawIllustration.empty,
                color: Colors.lightGreen),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                      text:
                          'You have no sub-labels defined under parent label '),
                  TextSpan(
                      text: tag.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Text(
                'Sub-labels allow for a more fine-grained grouping of items under the parent label',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: addCallback,
              child: const Text('Add 1st one'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NewLabelDialog extends StatefulWidget {
  final Tag tag;

  const _NewLabelDialog({Key? key, required this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewLabelDialogState();
  }
}

class _NewLabelDialogState extends State<_NewLabelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String _label = '';
  bool _loading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {
        _label = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create label'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Label name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorText: _errorText,
            errorMaxLines: 3,
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        TextButton(
            onPressed: _label.isNotEmpty && !_loading
                ? () async {
                    var cli = GraphQLProvider.of(context).value;
                    setState(() {
                      _loading = true;
                    });
                    var result = await cli.mutate(
                      MutationOptions(
                        document: mutationCreateSubLabel,
                        variables: {
                          "tagID": widget.tag.id!,
                          "input": {
                            "name": _label,
                          }
                        },
                      ),
                    );
                    if (result.hasException) {
                      setState(() {
                        _loading = false;
                        _errorText = 'Unable to add label';
                      });
                    } else {
                      setState(() {
                        _loading = false;
                      });
                      var snackBar = const SnackBar(
                          content: Text('The label has been added'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            child: Text(_loading ? 'Adding...' : 'Add')),
      ],
    );
  }
}

enum _SubLabelActions {
  delete,
  add,
  rename,
}

/// _SubLabelEntryPopupButton provides the popup menu button with contextual actions for a SubLabel as
/// defined by _SubLabelActions
class _SubLabelEntryPopupButton extends StatefulWidget {
  final SubLabel label;
  final Tag tag;
  final List<Item> labeledItems;
  final VoidCallback callback;
  const _SubLabelEntryPopupButton(
      {Key? key,
      required this.label,
      required this.tag,
      required this.labeledItems,
      required this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubLabelEntryPopupButtonState();
  }
}

class _SubLabelEntryPopupButtonState extends State<_SubLabelEntryPopupButton> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.label.name;
    // _controller.addListener(() {
    // setState(() {
    // _name = _controller.text;
    // });
    // });
  }

  void _onSelected(BuildContext context, _SubLabelActions value) async {
    switch (value) {
      case _SubLabelActions.add:
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 0,
            isScrollControlled: true,
            builder: (context) {
              return _ItemListSelect(
                  tag: widget.tag,
                  label: widget.label,
                  labeledItems: widget.labeledItems);
            }).whenComplete(() => widget.callback());
        break;
      case _SubLabelActions.delete:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  contentPadding:
                      const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                  title: const Text('Delete'),
                  content: const Text('Are you sure you want to delete label?'),
                  actions: [
                    TextButton(
                        child: const Text('No',
                            style: TextStyle(color: Colors.grey)),
                        onPressed: () => Navigator.of(context).pop()),
                    // Deletes the sublabel and refreshes the list of sublabels
                    TextButton(
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.redAccent)),
                      onPressed: () async {
                        var snackBar = const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Deletion in progress'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        var cli = GraphQLProvider.of(context).value;
                        var result = await cli.mutate(MutationOptions(
                            document: mutationDeleteSubLabel,
                            variables: {"subLabelID": widget.label.id}));
                        if (result.hasException) {
                          var snackBar = const SnackBar(
                              content: Text(
                                  'Unable to delete label. Kindly try again later'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          var snackBar = SnackBar(
                              content: Text(
                                  'Label \'${widget.label.name}\' has been deleted'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          widget.callback();
                        }
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
        break;
      case _SubLabelActions.rename:
        await showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: const [
                    Icon(Icons.edit),
                    Text('Edit label name', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                      enabled: !_loading,
                      controller: _controller,
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Label name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorText: _errorMessage,
                        errorMaxLines: 3,
                      )),
                ),
                actions: [
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            _controller.text = widget.label.name;
                          },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0XFFEFF5FB),
                        primary: const Color(0XFF296FA8)),
                    onPressed: _loading || _controller.text.isEmpty
                        ? null
                        : () async {
                            setState((() {
                              _loading = true;
                            }));
                            var cli = GraphQLProvider.of(context).value;
                            var result = await cli.mutate(MutationOptions(
                                document: mutationEditSubLabel,
                                variables: {
                                  'subLabelID': widget.label.id,
                                  'input': {
                                    'name': _controller.text,
                                  }
                                }));
                            setState((() {
                              _loading = false;
                            }));
                            if (result.hasException) {
                              setState(() {
                                _errorMessage =
                                    result.exception!.graphqlErrors[0].message;
                              });
                            } else {
                              var snackBar = const SnackBar(
                                  content:
                                      Text('Label name updated successfully'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).pop();
                            }
                          },
                    child: const Text('Save'),
                  ),
                ],
              );
            });
          },
          barrierDismissible: false,
        );
        setState(() {
          _errorMessage = null;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SubLabelActions>(
      onSelected: (value) => _onSelected(context, value),
      itemBuilder: (context) => const [
        PopupMenuItem(
            child: _ItemEntryItemWidget(
                text: 'Add items', icon: Icons.add, color: Colors.orangeAccent),
            value: _SubLabelActions.add),
        PopupMenuItem(
            child: _ItemEntryItemWidget(
              text: 'Edit name',
              icon: Icons.edit,
            ),
            value: _SubLabelActions.rename),
        PopupMenuItem(
            child: _ItemEntryItemWidget(
                text: 'Delete',
                icon: Icons.delete_sweep,
                color: Colors.redAccent),
            value: _SubLabelActions.delete),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

// _SubLabelEntry displayes all labels under the parent label
class _SubLabelEntry extends StatefulWidget {
  final SubLabel label;
  final Tag tag;
  final List<Item> labeledItems;
  final VoidCallback onItemAdded;

  const _SubLabelEntry({
    Key? key,
    required this.label,
    required this.tag,
    required this.labeledItems,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SublabelEntryState();
  }
}

class _SublabelEntryState extends State<_SubLabelEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SubLabelEntryPopupButton(
              label: widget.label,
              labeledItems: widget.labeledItems,
              tag: widget.tag,
              callback: widget.onItemAdded),
        ],
      ),
    );
  }
}

enum _itemEntryPopupMenu {
  view,
  remove,
}

// _ItemEntryItemWidget is an encapsulation of a single popup menu item entry child
class _ItemEntryItemWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _ItemEntryItemWidget(
      {Key? key,
      required this.text,
      required this.icon,
      this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(child: Text(text)),
      Icon(icon, color: color),
    ]);
  }
}

// _ItemEntryPopupButton is a PopupMenuButton widget that shows the options available
// to an Item under a specific sub-label
class _ItemEntryPopupButton extends StatelessWidget {
  final Item item;
  final SubLabel label;
  final VoidCallback onDelete;

  const _ItemEntryPopupButton(
      {Key? key,
      required this.item,
      required this.label,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_itemEntryPopupMenu>(
      onSelected: (value) {
        switch (value) {
          case _itemEntryPopupMenu.view:
            var settings =
                ShoppingItemRouteSettings(itemId: item.id!, name: item.name);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShoppingItemDetailPage(),
                settings: RouteSettings(arguments: settings)));
            break;
          case _itemEntryPopupMenu.remove:
            var removing = false;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Row(
                      children: const [
                        Icon(Icons.delete_outlined, color: Color(0xFFcc0f35)),
                        Text('Remove',
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xFFcc0f35))),
                      ],
                    ),
                    content: const Text(
                        'Are you sure you want to remove this item from the label?'),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    actions: [
                      StatefulBuilder(builder: (context, setState) {
                        return Row(mainAxisSize: MainAxisSize.min, children: [
                          TextButton(
                            onPressed: removing
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('No, cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 10.0),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFfeecf0),
                                primary: const Color(0Xffcc0f35)),
                            onPressed: removing
                                ? null
                                : () async {
                                    setState(() {
                                      removing = true;
                                    });
                                    var successful = await _remove(context);
                                    if (successful) {
                                      var snackBar = const SnackBar(
                                          content: Text(
                                              'Item has been successfully remove'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      var snackBar = const SnackBar(
                                          content: Text(
                                              'Unable to remove item from label'),
                                          backgroundColor: Color(0xFFfeecf0));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    setState(() {
                                      removing = false;
                                    });
                                    onDelete();
                                    Navigator.of(context).pop();
                                  },
                            child: Text(
                              removing ? 'Removing...' : 'Yes, remove',
                            ),
                          )
                        ]);
                      }),
                    ],
                  );
                });
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
            child: _ItemEntryItemWidget(
                text: 'Item details', icon: Icons.chevron_right),
            value: _itemEntryPopupMenu.view),
        PopupMenuItem(
            child: _ItemEntryItemWidget(
                text: 'Remove from label',
                icon: Icons.delete,
                color: Colors.redAccent),
            value: _itemEntryPopupMenu.remove),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Future<bool> _remove(BuildContext context) async {
    var cli = GraphQLProvider.of(context).value;
    var result = await cli.mutate(
        MutationOptions(document: mutationRemoveItemsFromSubLabel, variables: {
      'subLabelID': label.id,
      'itemIDs': [item.id],
    }));

    if (result.hasException) return false;
    return true;
  }
}

/// _ItemEntry is a single item widget that is displayed under a specific sub-label
class _ItemEntry extends StatelessWidget {
  final Item item;
  final SubLabel label;
  final VoidCallback onDelete;

  const _ItemEntry(
      {Key? key,
      required this.item,
      required this.label,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0.0),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            children: [
              const SizedBox(width: 30.0),
              Expanded(
                child: Text(item.name,
                    style: const TextStyle(color: Colors.black87)),
              ),
              const SizedBox(width: 6.0),
              _ItemEntryPopupButton(
                  item: item, label: label, onDelete: onDelete),
              const SizedBox(width: 20.0),
            ],
          ),
          const SizedBox(height: 10.0),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

/// _ItemListSelect allows the user to select the specific set of items to add to a
/// sub-label
class _ItemListSelect extends StatefulWidget {
  final Tag tag;
  final SubLabel label;
  final List<Item> labeledItems;

  const _ItemListSelect(
      {Key? key,
      required this.tag,
      required this.label,
      required this.labeledItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemListSelectState();
  }
}

class _ItemListSelectState extends State<_ItemListSelect> {
  final List<Item> _selectedItems = [];
  bool _saving = false;

  void _toggleSelected(Item item) {
    var index = _selectedItems.indexWhere((element) => element.id == item.id);
    setState(() {
      if (index == -1) {
        _selectedItems.add(item);
      } else {
        _selectedItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height * 0.75;
    var width = size.width * 0.50;

    var radius = const Radius.circular(20.0);
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height, maxWidth: width),
        child: Query(
          options: QueryOptions(document: itemsQuery, variables: {
            "tagID": widget.tag.id!,
          }),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (result.hasException) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Text('Unable to load items'),
              );
            }

            var items = Items.fromJson(result.data!);
            var values = items.items.where((element) {
              return widget.labeledItems
                      .indexWhere((i) => element.id == i.id) ==
                  -1;
            }).toList();

            return Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: radius, topRight: radius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.drag_handle_rounded,
                          color: Colors.grey,
                        ),
                        Center(
                            child: Text('Select items',
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        SizedBox(height: 15.0),
                        Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 58.0, bottom: 50.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        if (values.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Text('All items have been labeled'),
                          ),
                        for (var i in values)
                          CheckboxListTile(
                              value: _selectedItems
                                  .any((element) => element.id == i.id),
                              onChanged: (selected) {
                                _toggleSelected(i);
                              },
                              title: Text(i.name),
                              dense: true),
                      ],
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                          onPressed: _selectedItems.isEmpty || _saving
                              ? null
                              : () {
                                  var cli = GraphQLProvider.of(context).value;
                                  setState(() {
                                    _saving = true;
                                  });
                                  var result = cli.mutate(
                                    MutationOptions(
                                      document: mutationAddItemsToSubLabel,
                                      variables: {
                                        'subLabelID': widget.label.id,
                                        'itemIDs': _selectedItems
                                            .map((e) => e.id)
                                            .toList()
                                      },
                                    ),
                                  );
                                  result.then((result) {
                                    if (!result.hasException) {
                                      var snackBar = const SnackBar(
                                          content:
                                              Text('Items added successfully'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }).whenComplete(() {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.of(context).pop();
                                  });
                                },
                          child: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                              elevation: 3, shadowColor: Colors.transparent))),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
