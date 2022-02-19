import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/constants.dart';
import '../gql/gql.dart';
import '../models/model.dart';

class SelectLabelPage extends StatelessWidget {
  const SelectLabelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Refetch? _refetch;
    var args =
        ModalRoute.of(context)!.settings.arguments as SelectLabelSettings;
    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(title: const Text('Select label')),
      body: Query(
          options: QueryOptions(document: labelsQuery),
          builder: (QueryResult result,
              {FetchMore? fetchMore, Refetch? refetch}) {
            _refetch = refetch;
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (result.hasException) {
              return const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                  child: Text('Unable to load labels'),
                ),
              );
            }
            var labels = Tags.fromJson(result.data!);
            return RefreshIndicator(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    for (var label in labels.tags)
                      Container(
                        color: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              var cli = GraphQLProvider.of(context).value;
                              var future = cli.mutate(MutationOptions(
                                  document: mutationTagItems,
                                  variables: {
                                    "itemIDs": args.itemIds,
                                    'tagID': label.id!,
                                  }));
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return WillPopScope(
                                      child: AlertDialog(
                                        content: Row(children: [
                                          const CircularProgressIndicator(),
                                          const SizedBox(width: 15),
                                          Expanded(
                                              child: Text(
                                                  'Adding items to label \'${label.name}\''))
                                        ]),
                                      ),
                                      onWillPop: () {
                                        return future.then<bool>((value) {
                                          if (value.isLoading) return false;
                                          return true;
                                        });
                                      },
                                    );
                                  });
                              future.then((result) {
                                if (result.data != null) {
                                  Navigator.popUntil(context,
                                      ModalRoute.withName(cataloguePage));
                                  var snackBar = SnackBar(
                                    content: Text(
                                        'Items have been added to label \'${label.name}\''),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  Navigator.popUntil(context,
                                      ModalRoute.withName(cataloguePage));
                                  var snackBar = SnackBar(
                                    content: Text(
                                        'Unable to add items to label \'${label.name}\''),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            },
                            splashColor: Colors.black38,
                            child: ListTile(
                              leading: const Icon(Icons.label_outline),
                              title: Text(label.name,
                                  style: const TextStyle(fontSize: 16.0)),
                              dense: true,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      color: Colors.transparent,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => _NewLabelDialog(
                                      refetchLabels: () {
                                        if (_refetch != null) {
                                          _refetch!();
                                        }
                                      },
                                    ));
                          },
                          splashColor: Colors.black38,
                          child: const ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Create new...'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onRefresh: () {
                  if (_refetch != null) {
                    return _refetch!();
                  }
                  return Future.value(null);
                });
          }),
    );
  }
}

class _NewLabelDialog extends StatefulWidget {
  final VoidCallback refetchLabels;

  const _NewLabelDialog({Key? key, required this.refetchLabels})
      : super(key: key);

  @override
  State createState() => _NewLabelDialogState();
}

class _NewLabelDialogState extends State<_NewLabelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String _label = '';

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
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: _label.isNotEmpty
                ? () {
                    var cli = GraphQLProvider.of(context).value;
                    var future = cli.mutate(MutationOptions(
                        document: mutationCreateLabel,
                        variables: {
                          "input": Tag(name: _label).toJson(),
                        }));
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AlertDialog(
                                  content: Row(
                                      children: const [Text('Done')],
                                      mainAxisAlignment:
                                          MainAxisAlignment.center),
                                );
                              }
                              return AlertDialog(
                                content: Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text('Saving...'),
                                  ],
                                ),
                              );
                            });
                      },
                    ).then(
                      (value) {
                        widget.refetchLabels();
                      },
                    );
                  }
                : null,
            child: const Text('Ok')),
      ],
    );
  }
}

class SelectLabelSettings {
  final List<int> itemIds;

  SelectLabelSettings({required this.itemIds});
}
