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
  final VoidCallback? onRoutePop;

  const SimpleBar(
      {Key? key,
      required this.title,
      required this.value,
      required this.max,
      required this.total,
      this.showPercentage = false,
      this.entry,
      this.onRoutePop})
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
          if (mounted) {
            setState(() {
              var result = per * w;
              if (width != result) {
                width = result;
              }
            });
          }
        });
        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black12,
            onTap: entry != null
                ? () async {
                    await entry?.goTo(context);
                    widget.onRoutePop?.call();
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
                                child: Tooltip(
                                  message: widget.title,
                                  showDuration: const Duration(seconds: 5),
                                  child: Text(
                                    widget.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
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

class DraggableSimpleBar<E extends Object> extends StatelessWidget {
  final Widget child;
  final E data;

  const DraggableSimpleBar({Key? key, required this.child, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.drag_indicator),
          const SizedBox(width: 5),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: child,
          ),
        ],
      ),
      feedback: Container(
        width: 250,
        height: 60,
        child: child,
        padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
      ),
      data: data,
    );
  }
}

class TargetSimpleBar<E extends Object> extends StatelessWidget {
  final Widget child;
  final void Function(E) onAccept;

  const TargetSimpleBar({Key? key, required this.child, required this.onAccept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<E>(
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isEmpty) {
          return child;
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        );
      },
      onAccept: onAccept,
    );
  }
}

// class _TargetSimpleBar<E extends Object> extends State<TargetSimpleBar> {
// @override
// Widget build(BuildContext context) {
// return DragTarget(builder: (context, candidateData, rejectedData) {
// if (candidateData.isEmpty) {
// return widget.child;
// }
//
// return Container(
// decoration: BoxDecoration(
// border: Border.all(color: Colors.lightGreenAccent),
// ),
// child: widget.child,
// );
// });
// }
// }

enum SimpleBarEntryType {
  label,
  group,
}

class SimpleBarEntry<E> {
  final String label;
  final double value;
  final List<E> items;
  final SimpleBarEntryType type;

  /// Used when the simple label entry is a group of other entries
  final List<String> children;

  const SimpleBarEntry(
      {required this.label,
      required this.value,
      required this.items,
      this.type = SimpleBarEntryType.label,
      this.children = const []});

  factory SimpleBarEntry.empty(String label) =>
      SimpleBarEntry(label: label, value: 0, items: []);

  SimpleBarEntry<E> operator +(SimpleBarEntry<E> other) {
    return add(other);
  }

  SimpleBarEntry<E> add(SimpleBarEntry<E> other) {
    var newLabel = label;
    if (label != other.label) {
      newLabel = '$label + ${other.label}';
    }

    var children = <String>[];
    for (var entry in <SimpleBarEntry<E>>[this, other]) {
      switch (entry.type) {
        case SimpleBarEntryType.label:
          children.add(entry.label);
          break;
        case SimpleBarEntryType.group:
          children.addAll(entry.children);
          break;
      }
    }

    return SimpleBarEntry(
      label: newLabel,
      value: value + other.value,
      items: [...items, ...other.items],
      children: children,
    );
  }

  int compareTo(SimpleBarEntry<E> other) => value > other.value
      ? 1
      : value < other.value
          ? -1
          : 0;
}

class StatSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget> actions;

  const StatSection(
      {Key? key, this.title, required this.child, this.actions = const []})
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
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: title != null
                    ? Text(title!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.grey))
                    : const SizedBox(width: 1),
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

class StatSectionWrapper<E> extends StatelessWidget {
  final String? title;
  final SortedList<SimpleBarEntry<E>> entries;
  final bool truncate;
  final int initialCount;

  /// groups are created when entries are drag-n-dropped
  final ValueNotifier<Map<String, List<String>>>? groups;

  /// Should be called when one of the children causes a navigation to a differentroute
  /// which causes a change in state that would necessitate an update on the current route which StatSectionWrapper finds itself.
  final VoidCallback? onRoutePop;

  /// Call when a drag-n-drop is performed
  final Function(SimpleBarEntry<E>, SimpleBarEntry<E>)? onMerge;

  const StatSectionWrapper(
      {Key? key,
      this.title,
      required this.entries,
      this.truncate = false,
      this.initialCount = 10,
      this.onRoutePop,
      this.groups,
      this.onMerge})
      : super(key: key);

  void _merge(SimpleBarEntry<E> item1, SimpleBarEntry<E> item2) {
    if (item1.label == item2.label) {
      return;
    }

    if (onMerge != null) {
      onMerge!(item1, item2);
    }
  }

  @override
  Widget build(BuildContext context) {
    var max = 0.0;
    if (entries.isNotEmpty) {
      max = entries.last.value;
    }
    var result = entries.reduce((value, element) => value + element);
    var total = result.value;

    // var initialCount = _count > entries.length ? entries.length : _count;

    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 400),
      child: StatSection(
        title: title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var entry in false // TODO: Implement this
                ? entries.reversed.toList().sublist(0, 5)
                : entries.reversed)
              TargetSimpleBar<SimpleBarEntry<E>>(
                child: DraggableSimpleBar<SimpleBarEntry<E>>(
                  child: SimpleBar(
                    title: entry.label,
                    value: entry.value,
                    entry: entry,
                    max: max,
                    // TODO: implement this
                    showPercentage: false,
                    total: total,
                    onRoutePop: onRoutePop,
                  ),
                  data: entry,
                ),
                onAccept: (item) {
                  _merge(item, entry);
                },
              ),
            if (entries.isEmpty) const Text('No data'),
            // TODO: Implement this
            // if (_showToggleButton)
            // Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            // CircleAvatar(
            // child: IconButton(
            // iconSize: 16,
            // onPressed: _isUpwardEnabled()
            // ? () {
            // setState(() {
            // _count = initialCount;
            // });
            // }
            // : null,
            // icon: const Icon(Icons.arrow_upward))),
            // const SizedBox(width: 5),
            // CircleAvatar(
            // child: IconButton(
            // iconSize: 16,
            // onPressed: _isDownloadEnabled()
            // ? () {
            // setState(() {
            // _count = initialCount + initialCount;
            // });
            // }
            // : null,
            // icon: const Icon(Icons.arrow_downward))),
            // ],
            // ),
          ],
        ),
        actions: [
          // TODO: implement this
          // CircleAvatar(
          // radius: 15,
          // child: IconButton(
          // onPressed: () {
          // setState(() {
          // _showPercentage = !_showPercentage;
          // });
          // },
          // icon: const Icon(Icons.percent),
          // iconSize: 14.0,
          // ),
          // ),
        ],
      ),
    );
  }
}

// class _StatSectionWrapper<E> extends State<StatSectionWrapper<E>> {
// final bool _truncated = true;
// late final bool _showToggleButton;
// bool _showPercentage = false;
// int _count = 0;
//
// @override
// void initState() {
// super.initState();
// _showToggleButton =
// widget.initialCount < widget.entries.length && widget.truncate;
// _count = widget.initialCount;
// }
//
// bool _isUpwardEnabled() {
// return _count > widget.initialCount;
// }
//
// bool _isDownloadEnabled() {
// return _count < widget.entries.length;
// }
//
// void _updateGroup(SimpleBarEntry<E> item1, SimpleBarEntry<E> item2) {
// if (widget.onMerge != null) {
// widget.onMerge!(item1, item2);
// }
// }
//
// void _merge(SimpleBarEntry<E> item, SimpleBarEntry<E> into) {
// if (item.label == into.label) {
// return;
// }
//
// _updateGroup(item, into);
//
// // var indexInto = widget.entries.indexWhere((i) => i.label == into.label);
// // if (indexInto == -1) {
// // return;
// // }
// //
// // widget.entries.removeAt(indexInto);
// // var indexItem = widget.entries.indexWhere((i) => i.label == item.label);
// // if (indexInto == -1) {
// // return;
// // }
// // widget.entries.removeAt(indexItem);
// // var newEntry = into.add(item);
// // setState(() {
// // widget.entries.add(newEntry);
// // });
// }
//
// @override
// Widget build(BuildContext context) {
// var max = 0.0;
// if (widget.entries.isNotEmpty) {
// max = widget.entries.last.value;
// }
// var result = widget.entries.reduce((value, element) => value + element);
// var total = result.value;
//
// var initialCount =
// _count > widget.entries.length ? widget.entries.length : _count;
//
// return AnimatedSize(
// alignment: Alignment.topCenter,
// duration: const Duration(milliseconds: 400),
// child: StatSection(
// title: widget.title ?? '' '${widget.groups?.value.toString()}',
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// for (var entry in _truncated
// ? widget.entries.reversed.toList().sublist(0, initialCount)
// : widget.entries.reversed)
// TargetSimpleBar<SimpleBarEntry<E>>(
// child: DraggableSimpleBar<SimpleBarEntry<E>>(
// child: SimpleBar(
// title: entry.label,
// value: entry.value,
// entry: entry,
// max: max,
// showPercentage: _showPercentage,
// total: total,
// onRoutePop: widget.onRoutePop,
// ),
// data: entry,
// ),
// onAccept: (item) {
// _merge(item, entry);
// },
// ),
// if (widget.entries.isEmpty) const Text('No data'),
// if (_showToggleButton)
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// CircleAvatar(
// child: IconButton(
// iconSize: 16,
// onPressed: _isUpwardEnabled()
// ? () {
// setState(() {
// _count = widget.initialCount;
// });
// }
// : null,
// icon: const Icon(Icons.arrow_upward))),
// const SizedBox(width: 5),
// CircleAvatar(
// child: IconButton(
// iconSize: 16,
// onPressed: _isDownloadEnabled()
// ? () {
// setState(() {
// _count = initialCount + widget.initialCount;
// });
// }
// : null,
// icon: const Icon(Icons.arrow_downward))),
// ],
// ),
// ],
// ),
// actions: [
// CircleAvatar(
// radius: 15,
// child: IconButton(
// onPressed: () {
// setState(() {
// _showPercentage = !_showPercentage;
// });
// },
// icon: const Icon(Icons.percent),
// iconSize: 14.0,
// ),
// ),
// ],
// ),
// );
// }
// }

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
