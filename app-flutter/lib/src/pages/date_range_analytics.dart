// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
  const _AnalyticsHeaderDateRange(
      {Key? key, required this.start, required this.end})
      : super(key: key);

  final DateTime start;
  final DateTime end;

  int get _diffInDays {
    return end.difference(start).inDays;
  }

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
            if (_diffInDays > 1) ...[
              const SizedBox(width: 5.0),
              const Icon(Icons.arrow_right),
              const SizedBox(width: 5.0),
              Text(
                  DateFormat('EEE, MMM d')
                      .format(end.subtract(const Duration(days: 1))),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 14)),
            ]
          ],
        )
      ],
    );
  }
}

class DateRangeAnalytics extends HookWidget {
  final AnalyticsForSettings analyticsFor;

  const DateRangeAnalytics({Key? key, required this.analyticsFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = useState<AnalyticsForSettings>(analyticsFor);
    var total = 0.0;
    final purchasesQueryResult = useQuery(
      QueryOptions(
        document: purchasesExpandedQuery,
        variables: {
          'after': DateTimeToJson(settings.value.start),
          'before': DateTimeToJson(settings.value.end),
        },
      ),
    );
    final result = purchasesQueryResult.result;
    final refetch = purchasesQueryResult.refetch;
    Widget body;
    var groups = useState(<String, List<String>>{});
    var doGrouping = useState(false);

    if (result.isLoading && result.data == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (result.hasException) {
      body = Padding(
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
                  refetch();
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
    } else {
      var purchases = Purchases.fromJson(result.data!);
      var byLabel = doGrouping.value
          ? _doMerging(purchases, settings.value, groups.value)
          : _filterByTag(purchases, settings.value);
      var byVendor = _filterByVendor(purchases);
      var byItem = _filterByItem(purchases);

      if (purchases.purchases.isEmpty) {
        body = Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UnDraw(
                    height: 150.0,
                    illustration: UnDrawIllustration.analytics,
                    color: Colors.redAccent),
                const Text('No data to show', style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        );
      } else {
        for (var purchase in purchases.purchases) {
          total += purchase.total!;
        }
        // ignore: prefer_function_declarations_over_variables
        RefreshCallback onRefresh = () async {
          await refetch();
          return;
        };
        body = NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: const Icon(Icons.analytics),
                title: AnalyticsHeader(analyticsFor: settings.value),
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
                      left: 40.0, top: 20.0, bottom: 20.0),
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
                hasGroups: groups.value.isNotEmpty,
                grouped: doGrouping.value,
                child: StatSectionWrapper(
                  entries: byLabel,
                  truncate: true,
                  onRoutePop: () {
                    refetch();
                  },
                  onMerge: (item1, item2) {
                    final children = <String>[];
                    var grps = groups.value;

                    for (var entry in <SimpleBarEntry>[item1, item2]) {
                      switch (entry.type) {
                        case SimpleBarEntryType.label:
                          children.add(entry.label);
                          break;
                        case SimpleBarEntryType.group:
                          // We need to remove it from the groups
                          final entries = grps.remove(entry.label);
                          if (entries != null) {
                            children.addAll(entries);
                          }
                          break;
                      }
                    }
                    grps['${item1.label} + ${item2.label}'] = children;
                    doGrouping.value = true;
                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                    groups.notifyListeners();
                  },
                  groups: groups,
                ),
                onRefresh: onRefresh,
                toggleGrouping: () {
                  doGrouping.value = !doGrouping.value;
                },
                clearGroups: () {
                  groups.value.clear();
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  groups.notifyListeners();
                },
              ),
              TabBarChild(
                grouped: doGrouping.value,
                child: StatSectionWrapper(entries: byVendor, truncate: true),
                onRefresh: onRefresh,
                toggleGrouping: () {
                  doGrouping.value = !doGrouping.value;
                },
              ),
              TabBarChild(
                grouped: doGrouping.value,
                child: StatSectionWrapper(entries: byItem, truncate: true),
                onRefresh: onRefresh,
                toggleGrouping: () {
                  doGrouping.value = !doGrouping.value;
                },
              ),
            ],
          ),
        );
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        body: body,
      ),
    );
  }

  SortedList<SimpleBarEntry<PurchaseItem>> _doMerging(Purchases purchases,
      AnalyticsForSettings analyticsFor, Map<String, List<String>> groups) {
    var result =
        SortedList<SimpleBarEntry<PurchaseItem>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<PurchaseItem>>{};
    var grouped = <String, SimpleBarEntry<PurchaseItem>>{};

    purchases.purchases.forEach((purchase) {
      purchase.items!.forEach((purchaseItem) {
        // Check if the tag for the item belongs to a group
        var label = "uncategorized";
        if (purchaseItem.item?.tags?.isNotEmpty ?? false) {
          label = purchaseItem.item!.tags![0].name;
        }

        var found = false;
        for (var entry in groups.entries) {
          if (entry.value.contains(label)) {
            grouped.update(
                entry.key,
                (existing) => SimpleBarEntry(
                      label: entry.key,
                      value: existing.value + purchaseItem.total,
                      items: [...existing.items, purchaseItem],
                      type: SimpleBarEntryType.group,
                    ),
                ifAbsent: () => SimpleBarEntry(
                      label: entry.key,
                      value: purchaseItem.total,
                      items: [purchaseItem],
                    ));
            found = true;
            break;
          }
        }
        if (!found) {
          var entry = LabelsSimpleBarEntry(
            label: label,
            value: purchaseItem.total,
            items: [purchaseItem],
            labelId:
                label == 'uncategorized' ? 0 : purchaseItem.item!.tags![0].id!,
            analyticsFor: analyticsFor,
          );
          map.update(label, (value) => value + entry, ifAbsent: () => entry);
        }
      });
    });

    map.values.forEach((entry) => result.add(entry));
    grouped.values.forEach((entry) => result.add(entry));
    return result;
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
          label: purchase.vendor!.name,
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
  final bool grouped;
  final VoidCallback toggleGrouping;
  final bool hasGroups;
  final VoidCallback? clearGroups;

  const TabBarChild(
      {Key? key,
      required this.child,
      required this.onRefresh,
      required this.grouped,
      required this.toggleGrouping,
      this.hasGroups = false,
      this.clearGroups})
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
                child: Column(
                  children: [
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (hasGroups)
                          ElevatedButton(
                            onPressed: toggleGrouping,
                            child: Text(grouped ? 'Ungroup' : 'Show groupings'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                          ),
                        if (hasGroups && clearGroups != null) ...[
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: clearGroups!,
                            child: const Text('Clear groups'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                          ),
                        ],
                      ],
                    ),
                    child,
                  ],
                ),
              ),
            ),
          ),
          onRefresh: onRefresh,
        );
      },
    );
  }
}
