/// Defines the page that shows sub-labels of a specific label and the
/// Items that are under each sub-label
import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/model.dart';
import '../gql/gql.dart';

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
                          return Slidable(
                            key: ValueKey(child.id),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      24.0, 20.0, 24.0, 0),
                                              title: const Text('Delete'),
                                              content: const Text(
                                                  'Are you sure you want to delete label?'),
                                              actions: [
                                                TextButton(
                                                    child: const Text('No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop()),
                                                // Deletes the sublabel and refreshes the list of sublabels
                                                TextButton(
                                                  child: const Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent)),
                                                  onPressed: () async {
                                                    var snackBar = const SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            'Deletion in progress'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    var cli =
                                                        GraphQLProvider.of(
                                                                context)
                                                            .value;
                                                    var result = await cli
                                                        .mutate(MutationOptions(
                                                            document:
                                                                mutationDeleteSubLabel,
                                                            variables: {
                                                          "subLabelID": child.id
                                                        }));
                                                    if (result.hasException) {
                                                      var snackBar = const SnackBar(
                                                          content: Text(
                                                              'Unable to delete label. Kindly try again later'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      var snackBar = SnackBar(
                                                          content: Text(
                                                              'Label \'${child.name}\' has been deleted'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      if (refetch != null) {
                                                        refetch();
                                                      }
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  },
                                  backgroundColor: Colors.redAccent,
                                  icon: Icons.delete,
                                  spacing: 10.0,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return _ItemListSelect(
                                              tag: widget.tag,
                                              label: child,
                                              labeledItems: labeledItems);
                                        }).whenComplete(() {
                                      if (refetch != null) {
                                        refetch();
                                      }
                                    });
                                  },
                                  backgroundColor: Colors.lightBlue,
                                  icon: Icons.add,
                                  spacing: 10.0,
                                  foregroundColor: Colors.white,
                                ),
                              ],
                            ),
                            child: _SubLabelEntry(
                              label: child,
                              tag: widget.tag,
                            ),
                          );
                        },
                        body: Column(
                          // shrinkWrap: true,
                          children: [
                            for (var item in child.items!)
                              _ItemEntry(item: item),
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

// _SubLabelEntry displayes all labels under the parent label
class _SubLabelEntry extends StatefulWidget {
  final SubLabel label;
  final Tag tag;

  const _SubLabelEntry({
    Key? key,
    required this.label,
    required this.tag,
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
          Text(
            widget.label.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class _ItemEntry extends StatelessWidget {
  final Item item;

  const _ItemEntry({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 20.0),
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
              const Icon(Icons.chevron_right),
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
