// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
import '../components/month_dropdown.dart';
import '../utils/flutter_hooks.dart';

var _format = NumberFormat('#,##0', 'en_US');

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({Key? key, required this.analyticsFor, this.onChanged})
      : super(key: key);

  final AnalyticsForSettings analyticsFor;
  final ValueChanged<DateTime>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (analyticsFor.analyticsFor == AnalyticsFor.month)
            _AnalyticsHeaderMonth(
                month: analyticsFor.month!,
                year: analyticsFor.year ?? DateTime.now().year,
                onChanged: onChanged),
          if (analyticsFor.analyticsFor == AnalyticsFor.dateRange)
            _AnalyticsHeaderDateRange(
                start: analyticsFor.start, end: analyticsFor.end),
        ]),
      ],
    );
  }
}

class _AnalyticsHeaderMonth extends HookWidget {
  const _AnalyticsHeaderMonth(
      {Key? key, required this.month, required this.year, this.onChanged})
      : super(key: key);

  final int month;
  final int year;
  final ValueChanged<DateTime>? onChanged;

  @override
  Widget build(BuildContext context) {
    var date = DateTime(year, month, 1);
    var dateValue = useState<DateTime>(date);
    var text = DateFormat('MMM yyy').format(dateValue.value);
    final link = useState<LayerLink>(LayerLink());
    final overlayEntry = useState<OverlayEntry?>(null);

    var rightEnabled = true;
    final now = DateTime.now();
    if (dateValue.value.month == now.month &&
        dateValue.value.year == now.year) {
      rightEnabled = false;
    }

    return GestureDetector(
      child: CompositedTransformTarget(
        link: link.value,
        child: WillPopScope(
          onWillPop: () async {
            if (overlayEntry.value != null) {
              overlayEntry.value!.remove();
              overlayEntry.value = null;
              return false;
            }
            return true;
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  final d = dateValue.value;
                  dateValue.value = DateTime(d.year, d.month - 1, 1);
                  if (onChanged != null) onChanged!(dateValue.value);
                },
                icon: const Icon(FeatherIcons.chevronLeft),
              ),
              const SizedBox(width: 5.0),
              Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(width: 5.0),
              IconButton(
                onPressed: rightEnabled
                    ? () {
                        final d = dateValue.value;
                        dateValue.value = DateTime(d.year, d.month + 1, 1);
                        if (onChanged != null) onChanged!(dateValue.value);
                      }
                    : null,
                icon: const Icon(FeatherIcons.chevronRight),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero);

        final overlay = Overlay.of(context);
        overlayEntry.value = OverlayEntry(
          builder: (context) => MonthPicker(
            year: dateValue.value.year,
            month: dateValue.value.month,
            link: link.value,
            offset: offset,
            onRemove: () {
              if (overlayEntry.value != null) {
                overlayEntry.value!.remove();
                overlayEntry.value = null;
              }
            },
            onValue: (DateTime d) {
              dateValue.value = d;
              if (overlayEntry.value != null) {
                overlayEntry.value!.remove();
                overlayEntry.value = null;
              }
              if (onChanged != null) {
                onChanged!(d);
              }
            },
          ),
        );
        overlay!.insert(overlayEntry.value!);
      },
    );
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

    bool purchasesEmpty = true;

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
        purchasesEmpty = false;
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
                title: AnalyticsHeader(
                  analyticsFor: settings.value,
                  onChanged: (d) {
                    settings.value = AnalyticsForSettings(
                        analyticsFor: AnalyticsFor.month,
                        month: d.month,
                        year: d.year);
                  },
                ),
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
              TabBarChild<PurchaseItem>(
                key: const ValueKey('tag'),
                entries: purchases,
                onRefresh: onRefresh,
                filterType: _FilterType.tag,
                analyticsFor: settings.value,
              ),
              TabBarChild<Purchase>(
                key: const ValueKey('vendor'),
                entries: purchases,
                onRefresh: onRefresh,
                filterType: _FilterType.vendor,
                analyticsFor: settings.value,
              ),
              TabBarChild<PurchaseItem>(
                key: const ValueKey('item'),
                entries: purchases,
                onRefresh: onRefresh,
                filterType: _FilterType.item,
                analyticsFor: settings.value,
              ),
            ],
          ),
        );
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: purchasesEmpty
            ? AppBar(
                backgroundColor: mainScaffoldBg,
                leading: const Icon(Icons.analytics),
                title: AnalyticsHeader(
                  analyticsFor: settings.value,
                  onChanged: (d) {
                    settings.value = AnalyticsForSettings(
                        analyticsFor: AnalyticsFor.month,
                        month: d.month,
                        year: d.year);
                  },
                ),
                titleSpacing: 0.0,
              )
            : null,
        backgroundColor: mainScaffoldBg,
        body: body,
      ),
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

enum _FilterType {
  tag,
  vendor,
  item,
}

class TabBarChild<E> extends HookWidget {
  const TabBarChild({
    Key? key,
    required this.onRefresh,
    required this.entries,
    required this.filterType,
    required this.analyticsFor,
  }) : super(key: key);

  final RefreshCallback onRefresh;
  final Purchases entries;
  final _FilterType filterType;
  final AnalyticsForSettings analyticsFor;

  SortedList<SimpleBarEntry<E>> _doFilter(
      bool doGrouping, Map<String, List<String>> groups) {
    switch (filterType) {
      case _FilterType.tag:
        return doGrouping
            ? _doTagMerging(entries, analyticsFor, groups)
                as SortedList<SimpleBarEntry<E>>
            : _filterByTag(entries, analyticsFor)
                as SortedList<SimpleBarEntry<E>>;
      case _FilterType.vendor:
        return doGrouping
            ? _doVendorMerging(entries, groups) as SortedList<SimpleBarEntry<E>>
            : _filterByVendor(entries) as SortedList<SimpleBarEntry<E>>;
      case _FilterType.item:
        return doGrouping
            ? _doItemMerging(entries, groups) as SortedList<SimpleBarEntry<E>>
            : _filterByItem(entries) as SortedList<SimpleBarEntry<E>>;
    }
  }

  @override
  Widget build(BuildContext context) {
    final doGroupingValue = useState<bool>(false);
    final doGrouping = doGroupingValue.value;
    final groupsValue = useState<Map<String, List<String>>>({});
    final groups = groupsValue.value;
    useAutomaticKeepAlive();

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
                        if (groups.isNotEmpty)
                          ElevatedButton(
                            onPressed: () {
                              doGroupingValue.value = !doGrouping;
                            },
                            child:
                                Text(doGrouping ? 'Ungroup' : 'Show groupings'),
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
                        if (groups.isNotEmpty) ...[
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              groupsValue.value = {};
                            },
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
                    StatSectionWrapper(
                      entries: _doFilter(doGrouping, groups),
                      truncate: true,
                      onRoutePop: () {
                        onRefresh();
                      },
                      onMerge: (item1, item2) {
                        final children = <String>[];

                        for (var entry in <SimpleBarEntry>[item1, item2]) {
                          switch (entry.type) {
                            case SimpleBarEntryType.label:
                              children.add(entry.label);
                              break;
                            case SimpleBarEntryType.group:
                              // We need to remove it from the groups
                              final entries = groups.remove(entry.label);
                              if (entries != null) {
                                children.addAll(entries);
                              }
                              break;
                          }
                        }
                        groups['${item1.label} + ${item2.label}'] = children;
                        var g = <String, List<String>>{};
                        g.addAll(groups);
                        groupsValue.value = g;
                        doGroupingValue.value = true;
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        groupsValue.notifyListeners();
                      },
                      groups: groupsValue,
                    )
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
        items: [purchase],
        type: SimpleBarEntryType.label,
      );
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

  SortedList<SimpleBarEntry<PurchaseItem>> _doTagMerging(Purchases purchases,
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

  SortedList<SimpleBarEntry<Purchase>> _doVendorMerging(
      Purchases purchases, Map<String, List<String>> groups) {
    var result = SortedList<SimpleBarEntry<Purchase>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<Purchase>>{};
    var grouped = <String, SimpleBarEntry<Purchase>>{};

    purchases.purchases.forEach(
      (purchase) {
        var found = false;
        for (var group in groups.entries) {
          if (group.value.contains(purchase.vendor!.name)) {
            grouped.update(
              group.key,
              (existing) => SimpleBarEntry(
                label: group.key,
                value: existing.value + purchase.total!,
                items: [...existing.items, purchase],
                type: SimpleBarEntryType.group,
              ),
              ifAbsent: () => SimpleBarEntry(
                label: group.key,
                value: purchase.total!,
                items: [purchase],
              ),
            );
            found = true;
            break;
          }
        }
        if (!found) {
          final entry = SimpleBarEntry(
            label: purchase.vendor!.name,
            value: purchase.total!,
            items: [purchase],
            type: SimpleBarEntryType.label,
          );
          map.update(entry.label, (existing) => existing + entry,
              ifAbsent: () => entry);
        }
      },
    );
    map.values.forEach((entry) => result.add(entry));
    grouped.values.forEach((entry) => result.add(entry));
    return result;
  }

  SortedList<SimpleBarEntry<PurchaseItem>> _doItemMerging(
      Purchases purchases, Groups groups) {
    var result =
        SortedList<SimpleBarEntry<PurchaseItem>>((a, b) => a.compareTo(b));
    var map = <String, SimpleBarEntry<PurchaseItem>>{};
    var grouped = <String, SimpleBarEntry<PurchaseItem>>{};

    purchases.purchases.forEach(
      (purchase) {
        purchase.items!.forEach(
          (item) {
            var found = false;
            for (var group in groups.entries) {
              if (group.value.contains(item.item!.name)) {
                grouped.update(
                  group.key,
                  (existing) => SimpleBarEntry(
                    label: group.key,
                    value: item.total + existing.value,
                    items: [...existing.items, item],
                    type: SimpleBarEntryType.group,
                  ),
                  ifAbsent: () => SimpleBarEntry(
                    label: group.key,
                    value: item.total,
                    items: [
                      item,
                    ],
                  ),
                );
                found = true;
                break;
              }
            }
            if (!found) {
              var entry = SimpleBarEntry(
                label: item.item!.name,
                value: item.total,
                items: [item],
              );
              map.update(item.item!.name, (value) => value + entry,
                  ifAbsent: () => entry);
            }
          },
        );
      },
    );
    map.values.forEach((entry) => result.add(entry));
    grouped.values.forEach((entry) => result.add(entry));
    return result;
  }
}

typedef Groups = Map<String, List<String>>;
