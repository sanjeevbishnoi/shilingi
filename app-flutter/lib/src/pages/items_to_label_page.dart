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
                    for (var label in labels.tags)
                      ListTile(
                        leading: const Icon(Icons.tag),
                        title: Text(label.name),
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
