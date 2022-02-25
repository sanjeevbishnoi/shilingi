import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/model.dart';
import '../gql/gql.dart';

typedef ValueCallback<T> = void Function(T);

class EditLabelDialog extends StatefulWidget {
  final Tag tag;
  final VoidCallback? refreshLabels;
  final ValueCallback<String> onSuccess;

  const EditLabelDialog(
      {Key? key,
      required this.tag,
      this.refreshLabels,
      required this.onSuccess})
      : super(key: key);

  @override
  State createState() => _EditLabelDialog();
}

class _EditLabelDialog extends State<EditLabelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String _label = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _label = widget.tag.name;
    _controller.text = widget.tag.name;
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
      title: const Text('Rename label'),
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
                    var future = cli.mutate(
                        MutationOptions(document: mutationEditTag, variables: {
                      "id": widget.tag.id,
                      "input": Tag(name: _label).toJson(),
                    }));
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder<QueryResult>(
                            future: future,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                // Check if there is an error
                                if (snapshot.hasData) {
                                  var result = snapshot.data;
                                  if (result!.hasException) {
                                    var err =
                                        result.exception!.graphqlErrors[0];
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.error,
                                            color: Colors.redAccent,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(child: Text(err.message)),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  }
                                }

                                widget.onSuccess(_label);
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
                        if (widget.refreshLabels != null) {
                          widget.refreshLabels!();
                        }
                      },
                    );
                  }
                : null,
            child: const Text('Ok')),
      ],
    );
  }
}
