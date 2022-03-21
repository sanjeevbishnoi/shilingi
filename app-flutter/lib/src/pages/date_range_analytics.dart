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
          var byLabel = _filterByTag(purchases);
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

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalyticsHeader(
                      analyticsFor: analyticsFor,
                      purchases: purchases.purchases,
                    ),
                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 400),
                      child: InheritedSwitcherWrapper(
                        child: const CustomAnimatedSwitcher(),
                        switchable: StatSectionWrapper(
                            title: 'Expenditure by label',
                            entries: byLabel,
                            truncate: true),
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
        var entry = LabelsSimpleBarEntry(
            label: 'uncategorized',
            value: purchaseItem.total,
            items: [purchaseItem]);
        // Retrieve the tag for the item
        if (purchaseItem.item?.tags?.isNotEmpty ?? false) {
          entry = LabelsSimpleBarEntry(
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
  final bool canGoBack;
  final List<Widget> actions;

  const StatSection(
      {Key? key,
      required this.title,
      required this.child,
      this.canGoBack = false,
      this.actions = const []})
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
          Row(
            children: [
              if (canGoBack) ...[
                IconButton(
                  onPressed: () {
                    var inherited = InheritedWidgetSwitcher.of(context);
                    inherited?.goBack();
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.grey)),
              ),
              for (var action in actions) action,
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class StatSectionWrapper<E> extends StatefulWidget {
  final String title;
  final SortedList<SimpleBarEntry<E>> entries;
  final bool truncate;
  final int initialCount;
  final bool canGoBack;

  const StatSectionWrapper(
      {Key? key,
      required this.title,
      required this.entries,
      this.truncate = false,
      this.initialCount = 5,
      this.canGoBack = false})
      : super(key: key);

  @override
  State createState() => _StatSectionWrapper<E>();
}

class _StatSectionWrapper<E> extends State<StatSectionWrapper<E>> {
  bool _truncated = true;
  late final bool _showToggleButton;
  bool _showPercentage = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _showToggleButton =
        widget.initialCount < widget.entries.length && widget.truncate;
    _count = widget.initialCount;
  }

  bool _isUpwardEnabled() {
    return _count > widget.initialCount;
  }

  bool _isDownloadEnabled() {
    return _count < widget.entries.length;
  }

  @override
  Widget build(BuildContext context) {
    var max = 0.0;
    if (widget.entries.isNotEmpty) {
      max = widget.entries.last.value;
    }
    var result = widget.entries.reduce((value, element) => value + element);
    var total = result.value;

    var initialCount =
        _count > widget.entries.length ? widget.entries.length : _count;

    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 400),
      child: StatSection(
        title: widget.title,
        canGoBack: widget.canGoBack,
        child: Column(
          children: [
            for (var entry in _truncated
                ? widget.entries.reversed.toList().sublist(0, initialCount)
                : widget.entries.reversed)
              SimpleBar(
                title: entry.label,
                value: entry.value,
                entry: entry,
                max: max,
                showPercentage: _showPercentage,
                total: total,
              ),
            if (widget.entries.isEmpty) const Text('No data'),
            if (_showToggleButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      child: IconButton(
                          iconSize: 16,
                          onPressed: _isUpwardEnabled()
                              ? () {
                                  setState(() {
                                    _count = widget.initialCount;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.arrow_upward))),
                  const SizedBox(width: 5),
                  CircleAvatar(
                      child: IconButton(
                          iconSize: 16,
                          onPressed: _isDownloadEnabled()
                              ? () {
                                  setState(() {
                                    _count = initialCount + widget.initialCount;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.arrow_downward))),
                ],
              ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showPercentage = !_showPercentage;
                });
              },
              icon: const Icon(Icons.percent),
              iconSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleBar extends StatefulWidget {
  final String title;
  final double value;
  final double max;
  final double total;
  final SimpleBarEntry? entry;
  final bool showPercentage;

  const SimpleBar(
      {Key? key,
      required this.title,
      required this.value,
      required this.max,
      required this.total,
      this.showPercentage = false,
      this.entry})
      : super(key: key);

  @override
  State createState() => SimpleBarState();
}

class SimpleBarState extends State<SimpleBar> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    Widget? drilldown;
    if (widget.entry != null && widget.entry is NavigatableBarEntry) {
      drilldown = (widget.entry as NavigatableBarEntry).build(context);
    }

    var per = widget.value / widget.max;
    if (widget.showPercentage) {
      per = widget.value / widget.total;
    }
    var valueText = 'Kes ' + _format.format(widget.value);
    if (widget.showPercentage) {
      valueText = _format.format(per * 100) + '%';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        var w = constraints.maxWidth;
        Future.delayed(Duration.zero, () {
          setState(() {
            var result = per * w;
            if (width != result) {
              width = result;
            }
          });
        });
        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black12,
            onTap: drilldown != null
                ? () {
                    var model = InheritedWidgetSwitcher.of(context);
                    if (model != null) {
                      model.notifier.value = drilldown!;
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(widget.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600))),
                              Text(valueText),
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
                  ),
                  if (drilldown != null) ...[
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                    ),
                  ]
                ],
              ),
            ),
          ),
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

abstract class NavigatableBarEntry {
  Widget build(BuildContext context);
}

class LabelsSimpleBarEntry extends SimpleBarEntry<PurchaseItem>
    implements NavigatableBarEntry {
  const LabelsSimpleBarEntry(
      {required String label,
      required double value,
      required List<PurchaseItem> items})
      : super(label: label, value: value, items: items);

  /// TODO: We could find a way to optimize the building of the sorted list for purchase items
  @override
  Widget build(BuildContext context) {
    var sortedList =
        SortedList<SimpleBarEntry<PurchaseItem>>((a, b) => a.compareTo(b));
    var map = <int, SimpleBarEntry<PurchaseItem>>{};
    for (var item in items) {
      var entry = SimpleBarEntry(
          label: item.item!.name, value: item.total, items: [item]);
      map.update(item.item!.id!, (value) => value + entry,
          ifAbsent: () => entry);
    }
    map.values.forEach((element) => sortedList.add(element));

    return StatSectionWrapper(
      key: ValueKey(label),
      title: "Itemized breakdown",
      entries: sortedList,
      canGoBack: true,
      truncate: true,
    );
  }

  @override
  SimpleBarEntry<PurchaseItem> operator +(SimpleBarEntry<PurchaseItem> other) {
    return LabelsSimpleBarEntry(
        label: label,
        value: value + other.value,
        items: [...items, ...other.items]);
  }
}

class InheritedSwitcherWrapper extends StatefulWidget {
  final Widget switchable;
  final Widget child;

  const InheritedSwitcherWrapper(
      {Key? key, required this.switchable, required this.child})
      : super(key: key);

  @override
  State createState() => _InheritedSwitcherWrapper();
}

class _InheritedSwitcherWrapper extends State<InheritedSwitcherWrapper> {
  late final ValueNotifier<Widget> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.switchable);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetSwitcher(
        child: widget.child, notifier: notifier, initial: widget.switchable);
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }
}

/// TODO: Change this to InheritedNotifier
class InheritedWidgetSwitcher extends InheritedWidget {
  final ValueNotifier<Widget> notifier;
  final Widget initial;

  const InheritedWidgetSwitcher(
      {Key? key,
      required Widget child,
      required this.notifier,
      required this.initial})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedWidgetSwitcher? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedWidgetSwitcher>();

  void goBack() {
    notifier.value = initial;
  }
}

class CustomAnimatedSwitcher extends StatelessWidget {
  const CustomAnimatedSwitcher({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var notifier = InheritedWidgetSwitcher.of(context)!.notifier;
    return ListenerSwitch(notifier: notifier);
  }
}

class ListenerSwitch extends StatefulWidget {
  final ValueNotifier notifier;

  const ListenerSwitch({Key? key, required this.notifier}) : super(key: key);

  @override
  State createState() => ListenerSwitchState();
}

class ListenerSwitchState extends State<ListenerSwitch> {
  late Widget switchable;

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(() {
      setState(() {
        switchable = widget.notifier.value;
      });
    });
    switchable = widget.notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: switchable,
    );
  }
}
