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
          var byLabel = _filterByTag(purchases);
          var byVendor = _filterByVendor(purchases);
          var byItem = _filterByItem(purchases);

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatSectionWrapper(
                        title: 'Expenditure by label', entries: byLabel),
                    StatSectionWrapper(
                        title: 'Expenditure by vendor/store',
                        entries: byVendor),
                    StatSectionWrapper(
                        title: 'Itemized expenditure', entries: byItem),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SortedList<SimpleBarEntry<PurchaseItem>> _filterByTag(Purchases purchases) {
    var result =
        SortedList<SimpleBarEntry<PurchaseItem>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<PurchaseItem>>{};

    purchases.purchases.forEach((purchase) {
      purchase.items!.forEach((purchaseItem) {
        var entry = SimpleBarEntry<PurchaseItem>(
            label: 'uncategorized',
            value: purchaseItem.total,
            items: [purchaseItem]);
        // Retrieve the tag for the item
        if (purchaseItem.item?.tags?.isNotEmpty ?? false) {
          entry = SimpleBarEntry<PurchaseItem>(
              label: purchaseItem.item!.tags![0].name,
              value: purchaseItem.total,
              items: [purchaseItem]);
        }
        map.update(entry.label, (value) => value + entry,
            ifAbsent: () => entry);
      });
    });

    map.values.forEach((entry) => result.add(entry));
    return result;
  }

  SortedList<SimpleBarEntry<Purchase>> _filterByVendor(Purchases purchases) {
    var result = SortedList<SimpleBarEntry<Purchase>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<Purchase>>{};

    purchases.purchases.forEach((purchase) {
      var entry = SimpleBarEntry<Purchase>(
          label: purchase.vendor.name,
          value: purchase.total!,
          items: [purchase]);
      map.update(entry.label, (value) => value + entry, ifAbsent: () => entry);
    });

    map.values.forEach(
      (entry) => result.add(entry),
    );

    return result;
  }

  SortedList<SimpleBarEntry<PurchaseItem>> _filterByItem(Purchases purchases) {
    var result = SortedList<SimpleBarEntry<PurchaseItem>>(
      (a, b) => a.compareTo(b),
    );
    var map = <int, SimpleBarEntry<PurchaseItem>>{};

    purchases.purchases.forEach((purchase) {
      purchase.items!.forEach((item) {
        var entry = SimpleBarEntry(
            label: item.item!.name, value: item.total, items: [item]);
        map.update(item.item!.id!, (value) => value + entry,
            ifAbsent: (() => entry));
      });
    });

    map.values.forEach((element) => result.add(element));
    return result;
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
      margin: const EdgeInsets.only(bottom: 20.0),
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
      max = entries.last.value;
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

  factory SimpleBarEntry.empty(String label) =>
      SimpleBarEntry(label: label, value: 0, items: []);

  SimpleBarEntry<E> operator +(SimpleBarEntry<E> other) {
    return SimpleBarEntry(
        label: label,
        value: value + other.value,
        items: [...items, ...other.items]);
  }

  int compareTo(SimpleBarEntry<E> other) => value > other.value
      ? 1
      : value < other.value
          ? -1
          : 0;
}
