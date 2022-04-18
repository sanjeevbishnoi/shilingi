import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

import './settings/settings.dart';
import '../constants/constants.dart';
import '../gql/queries.dart';
import '../models/model.dart';
import './analytics_sub_pages/purchase_items_entries.dart';
import '../components/analytics/simple_bar.dart';

var _format = NumberFormat('#,##0', 'en_US');

class AnalyticsHeader extends StatelessWidget {
  final AnalyticsForSettings analyticsFor;
  final List<Purchase> purchases;

  const AnalyticsHeader(
      {Key? key, required this.analyticsFor, required this.purchases})
      : super(key: key);

  double get _totalSpend {
    var total = 0.0;
    for (var purchase in purchases) {
      total += purchase.total!;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.analytics),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (analyticsFor.analyticsFor == AnalyticsFor.month)
              _AnalyticsHeaderMonth(month: analyticsFor.month!),
            if (analyticsFor.analyticsFor == AnalyticsFor.dateRange)
              _AnalyticsHeaderDateRange(
                  start: analyticsFor.start, end: analyticsFor.end),
            const SizedBox(height: 12),
            Text('Kes ${_format.format(_totalSpend)}',
                style: const TextStyle(
                  fontSize: 22,
                )),
            const Text('Total spend', style: TextStyle(color: Colors.grey)),
          ]),
        ],
      ),
    );
  }
}

class _AnalyticsHeaderMonth extends StatelessWidget {
  final int month;

  const _AnalyticsHeaderMonth({Key? key, required this.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = DateTime(DateTime.now().year, month, 1);
    var text = DateFormat('MMMM').format(date);
    return Text('Analytics for $text',
        style: const TextStyle(
            fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 20));
  }
}

class _AnalyticsHeaderDateRange extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const _AnalyticsHeaderDateRange(
      {Key? key, required this.start, required this.end})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Analytics for',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(DateFormat('EEE, MMM d').format(start),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 14)),
            const SizedBox(width: 5.0),
            const Icon(Icons.arrow_right),
            const SizedBox(width: 5.0),
            Text(DateFormat('EEE, MMM d').format(end),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 14)),
          ],
        )
      ],
    );
  }
}

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
          var byLabel = _filterByTag(purchases, analyticsFor);
          var byVendor = _filterByVendor(purchases);
          var byItem = _filterByItem(purchases);

          if (purchases.purchases.isEmpty) {
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
                    const Text('No data to show',
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnalyticsHeader(
                        analyticsFor: analyticsFor,
                        purchases: purchases.purchases,
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: AnalyticsPageView(
                          pages: [
                            AnimatedSize(
                              alignment: Alignment.topCenter,
                              duration: const Duration(milliseconds: 400),
                              child: StatSectionWrapper(
                                title: 'Expenditure by label',
                                entries: byLabel,
                                truncate: true,
                                onRoutePop: () {
                                  refetch?.call();
                                },
                              ),
                            ),
                            StatSectionWrapper(
                                title: 'Expenditure by vendor/store',
                                entries: byVendor,
                                truncate: true),
                            StatSectionWrapper(
                                title: 'Itemized expenditure',
                                entries: byItem,
                                truncate: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onRefresh: () {
              if (refetch != null) {
                return refetch();
              }
              return Future.value(null);
            },
          );
        },
      ),
    );
  }

  SortedList<SimpleBarEntry<PurchaseItem>> _filterByTag(
      Purchases purchases, AnalyticsForSettings analyticsFor) {
    var result =
        SortedList<SimpleBarEntry<PurchaseItem>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<PurchaseItem>>{};

    purchases.purchases.forEach((purchase) {
      purchase.items!.forEach((purchaseItem) {
        var entry = LabelsSimpleBarEntry(
            labelId: 0,
            label: 'uncategorized',
            value: purchaseItem.total,
            items: [purchaseItem],
            analyticsFor: analyticsFor);
        // Retrieve the tag for the item
        if (purchaseItem.item?.tags?.isNotEmpty ?? false) {
          entry = LabelsSimpleBarEntry(
              labelId: purchaseItem.item!.tags![0].id!,
              label: purchaseItem.item!.tags![0].name,
              value: purchaseItem.total,
              items: [purchaseItem],
              analyticsFor: analyticsFor);
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

class AnalyticsPageView extends StatefulWidget {
  final List<Widget> pages;

  const AnalyticsPageView({Key? key, required this.pages}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnalyticsPageViewState();
  }
}

class _AnalyticsPageViewState extends State<AnalyticsPageView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0, viewportFraction: .9);
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _controller,
      children: [
        for (var page in widget.pages)
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: page,
          ),
      ],
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
