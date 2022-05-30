import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';

class MonthPicker extends HookWidget {
  const MonthPicker(
      {Key? key,
      required this.link,
      required this.onRemove,
      required this.offset,
      required this.onValue,
      this.enableFuture = false,
      this.month,
      this.year})
      : super(key: key);

  final LayerLink link;
  final VoidCallback onRemove;
  final Offset offset;
  final ValueChanged<DateTime> onValue;
  final int? year;
  final int? month;
  final bool enableFuture;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final yearValue = useState<int>(year ?? now.year);

    final radius = BorderRadius.circular(6.0);

    int monthCount = 12;
    if (!enableFuture && yearValue.value == now.year) {
      monthCount = now.month;
    } else if (!enableFuture && yearValue.value > now.year) {
      monthCount = 0;
    }

    return CompositedTransformFollower(
      link: link,
      targetAnchor: Alignment.bottomLeft,
      offset: Offset(-offset.dx, -offset.dy),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onRemove,
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Material(
                elevation: 8,
                borderRadius: radius,
                child: Container(
                  height: 230.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    color: mainScaffoldBg,
                    borderRadius: radius,
                  ),
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.black87,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Text('Date',
                                        style: TextStyle(color: Colors.white))),
                                TextButton(
                                  onPressed: () {
                                    final now = DateTime.now();
                                    onValue(DateTime(now.year, now.month, 1));
                                  },
                                  child: const Text(
                                    'THIS MONTH',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: ButtonStyle(
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    iconSize: 14.0,
                                    onPressed: onRemove,
                                    icon: const Icon(
                                      FeatherIcons.x,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                yearValue.value -= 1;
                              },
                              icon: const Icon(FeatherIcons.chevronLeft),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(yearValue.value.toString()),
                              ),
                            ),
                            IconButton(
                              onPressed: now.year == yearValue.value
                                  ? null
                                  : () {
                                      yearValue.value += 1;
                                    },
                              icon: const Icon(FeatherIcons.chevronRight),
                            ),
                          ],
                        ),
                        Expanded(
                          child: GridView.count(
                            childAspectRatio: 2.0,
                            crossAxisCount: 4,
                            padding: EdgeInsets.zero,
                            children: [
                              ...List<int>.generate(12, (index) => index)
                                  .map<Widget>(
                                (index) {
                                  final d =
                                      DateTime(yearValue.value, index + 1, 1);

                                  if (enableFuture || index + 1 <= monthCount) {
                                    TextStyle? style;
                                    if (month == index + 1 &&
                                        year == yearValue.value) {
                                      style = const TextStyle(
                                          color: Colors.greenAccent);
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        onValue(d);
                                      },
                                      child: Center(
                                        child: Text(
                                          DateFormat('MMM')
                                              .format(d)
                                              .toUpperCase(),
                                          style: style,
                                        ),
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: Text(
                                      DateFormat('MMM').format(d).toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
