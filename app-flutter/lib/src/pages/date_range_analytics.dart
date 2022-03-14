import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:sorted_list/sorted_list.dart';

import './settings/settings.dart';
import '../constants/constants.dart';
import '../gql/queries.dart';
import '../models/model.dart';

var _format = NumberFormat('#,##0', 'en_US');

class DateRangeAnalytics extends StatelessWidget {
  final AnalyticsForSettings analyticsFor;

  const DateRangeAnalytics({Key? key, required this.analyticsFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(title: const Text('Analytics')),
      body: Query(
        options: QueryOptions(
          document: purchasesExpandedQuery,
          variables: {
            'after': DateTimeToJson(analyticsFor.start),
            'before': DateTimeToJson(analyticsFor.end),
          },
        ),
        builder: (QueryResult result,
            {FetchMore? fetchMore, Refetch? refetch}) {
          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (result.hasException) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UnDraw(
                        height: 150.0,
                        illustration: UnDrawIllustration.warning,
                        color: Colors.redAccent),
                    const Text('Unable to load items',
                        style: TextStyle(fontSize: 18.0)),
                    TextButton(
                      onPressed: () {
                        if (refetch != null) refetch();
                      },
                      child: const Text('Try again'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          var purchases = Purchases.fromJson(result.data!);
          var expenditureByLabel = _filterByTag(purchases);
          var max = 0.0;
          if (expenditureByLabel.isNotEmpty) {
            max = expenditureByLabel.last.total;
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatSection(
                        title: 'Expenditure by label',
                        child: Column(
                          children: [
                            for (var tag in expenditureByLabel.reversed)
                              SimpleBar(
                                  title: tag.name,
                                  value: tag.total,
                                  width: tag.total / max),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SortedList<TagTotal> _filterByTag(Purchases purchases) {
    Map<String, TagTotal> result = {};
    var list = SortedList<TagTotal>((a, b) {
      if (a.total > b.total) {
        return 1;
      } else if (a.total < b.total) {
        return -1;
      }
      return 0;
    });
    purchases.purchases.forEach((purchase) {
      purchase.items?.forEach((item) {
        var isNotEmpty = item.item?.tags?.isNotEmpty;
        var tag = TagTotal(name: 'uncategorized', total: item.total);
        var name = 'uncategorized';
        if (isNotEmpty != null && isNotEmpty) {
          name = item.item!.tags![0].name;
          tag = TagTotal(name: name, total: item.total);
        }
        var total = result[name] ?? TagTotal(name: name, total: 0);
        result[tag.name] = total + tag;
      });
    });

    result.values.forEach((element) => list.add(element));
    return list;
  }
}

class StatSection extends StatelessWidget {
  final String title;
  final Widget child;

  const StatSection({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Colors.grey)),
          child,
        ],
      ),
    );
  }
}

class StatSectionWrapper<E> extends StatelessWidget {
  final String title;
  final SortedList<SimpleBarEntry<E>> entries;

  const StatSectionWrapper(
      {Key? key, required this.title, required this.entries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var max = 0.0;
    if (entries.isNotEmpty) {
      max = entries.reversed.last.value;
    }

    return StatSection(
        title: title,
        child: Column(
          children: [
            for (var entry in entries.reversed)
              SimpleBar(
                  title: entry.label,
                  value: entry.value,
                  width: entry.value / max),
          ],
        ));
  }
}

class SimpleBar extends StatefulWidget {
  final String title;
  final double value;
  final double width;

  const SimpleBar(
      {Key? key, required this.title, required this.value, required this.width})
      : super(key: key);

  @override
  State createState() => SimpleBarState();
}

class SimpleBarState extends State<SimpleBar> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var w = constraints.maxWidth;
        Future.delayed(Duration.zero, () {
          setState(() {
            var result = widget.width * w;
            if (width != result) {
              width = result;
            }
          });
        });
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(widget.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600))),
                    Text('Kes ' + _format.format(widget.value)),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutExpo,
                  width: width,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                )
              ]),
        );
      },
    );
  }
}

class TagTotal {
  final String name;
  final int? id;
  final double total;

  const TagTotal({required this.name, this.id, required this.total});

  TagTotal operator +(TagTotal other) {
    return TagTotal(name: name, total: total + other.total);
  }
}

class SimpleBarEntry<E> {
  final String label;
  final double value;
  final List<E> items;

  const SimpleBarEntry(
      {required this.label, required this.value, required this.items});
}
