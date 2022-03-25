import 'package:flutter/material.dart';

import 'package:sorted_list/sorted_list.dart';
import 'package:intl/intl.dart';

var _format = NumberFormat('#,##0', 'en_US');

abstract class NavigatableBarEntry {
  Future goTo(BuildContext context);
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
    NavigatableBarEntry? entry;
    if (widget.entry != null && widget.entry is NavigatableBarEntry) {
      entry = widget.entry as NavigatableBarEntry;
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
            onTap: entry != null
                ? () {
                    entry?.goTo(context);
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
                  if (entry != null) ...[
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
      this.initialCount = 10,
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
          mainAxisSize: MainAxisSize.min,
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

class TagTotal {
  final String name;
  final int? id;
  final double value;

  const TagTotal({required this.name, this.id, required this.value});

  TagTotal operator +(TagTotal other) {
    return TagTotal(name: name, value: value + other.value, id: id);
  }

  int compareTo(TagTotal other) => value > other.value
      ? 1
      : value < other.value
          ? -1
          : 0;
}
