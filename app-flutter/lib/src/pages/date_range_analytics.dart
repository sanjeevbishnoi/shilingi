import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:sorted_list/sorted_list.dart';

import './settings/settings.dart';
import '../constants/constants.dart';
import '../gql/queries.dart';
import '../models/model.dart';
import './analytics_sub_pages/purchase_items_entries.dart';
import '../components/analytics/simple_bar.dart';

var _format = NumberFormat('#,##0', 'en_US');

class AnalyticsHeader extends StatelessWidget {
  final AnalyticsForSettings analyticsFor;

  const AnalyticsHeader({Key? key, required this.analyticsFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (analyticsFor.analyticsFor == AnalyticsFor.month)
            _AnalyticsHeaderMonth(month: analyticsFor.month!),
          if (analyticsFor.analyticsFor == AnalyticsFor.dateRange)
            _AnalyticsHeaderDateRange(
                start: analyticsFor.start, end: analyticsFor.end),
        ]),
      ],
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
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20));
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(DateFormat('EEE, MMM d').format(start),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontSize: 14)),
            const SizedBox(width: 5.0),
            const Icon(Icons.arrow_right),
            const SizedBox(width: 5.0),
            Text(DateFormat('EEE, MMM d').format(end),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
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
    var body = Query(
      options: QueryOptions(
        document: purchasesExpandedQuery,
        variables: {
          'after': DateTimeToJson(analyticsFor.start),
          'before': DateTimeToJson(analyticsFor.end),
        },
      ),
      builder: (QueryResult result, {FetchMore? fetchMore, Refetch? refetch}) {
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
        var total = 0.0;
        for (var purchase in purchases.purchases) {
          total += purchase.total!;
        }

        RefreshCallback onRefresh = () async {
          await refetch?.call();
          return;
        };

        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: const Icon(Icons.analytics),
                title: AnalyticsHeader(analyticsFor: analyticsFor),
                floating: true,
                titleSpacing: 0.0,
                backgroundColor: Colors.lightGreen,
                expandedHeight: 70.0,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: mainScaffoldBg,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 54.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kes ${_format.format(total)}',
                          style: const TextStyle(
                            fontSize: 22,
                          )),
                      const Text('Total spend',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, top: 20.0, bottom: 30.0),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Categories'),
                      Tab(text: 'Vendors'),
                      Tab(text: 'Items'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              TabBarChild(
                child: StatSectionWrapper(
                  entries: byLabel,
                  truncate: true,
                  onRoutePop: () {
                    refetch?.call();
                  },
                ),
                onRefresh: onRefresh,
              ),
              TabBarChild(
                child: StatSectionWrapper(entries: byVendor, truncate: true),
                onRefresh: onRefresh,
              ),
              TabBarChild(
                child: StatSectionWrapper(entries: byItem, truncate: true),
                onRefresh: onRefresh,
              ),
            ],
          ),
        );
      },
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        body: body,
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

class TagTotal {
  final String name;
  final int? id;
  final double total;

  const TagTotal({required this.name, this.id, required this.total});

  TagTotal operator +(TagTotal other) {
    return TagTotal(name: name, total: total + other.total);
  }
}

class TabBarChild extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const TabBarChild({Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                minHeight: constraints.minHeight),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: child,
              ),
            ),
          ),
          onRefresh: onRefresh,
        );
      },
    );
  }
}
