/// Defines the page that shows sub-labels of a specific label and the
/// Items that are under each sub-label
import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shilingi/src/gql/mutations.dart';

import '../models/model.dart';

class LabelSubLabelsPages extends StatelessWidget {
  final Tag tag;

  const LabelSubLabelsPages({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sub-labels for ${tag.name}')),
      body: _EmptyLabelList(
        tag: tag,
        addCallback: () {
          _addLabel(context);
        },
      ),
    );
  }

  Future _addLabel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => _NewLabelDialog(tag: tag),
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
