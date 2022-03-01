import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../models/model.dart' as model;
import '../components/components.dart';
import '../gql/gql.dart' as queries;
import '../constants/constants.dart';
import '../style/style.dart';

var formatAmt = NumberFormat('#,##0.00', 'en_US');
var formatAmtWithoutDecimal =
    NumberFormat.compactCurrency(decimalDigits: 2, symbol: '');

class PurchasesPage extends StatefulWidget {
  const PurchasesPage([Key? key]) : super(key: key);

  @override
  State createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  DateTime focusedDay = DateTime.now();
  DateTime startDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  List<model.Purchase> purchases = [];
  List<model.Purchase> _rangePurchases = [];
  final Key visibilityKey = const Key('on-index-page');
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay = DateTime.now();
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [];
    if (_loading) {
      _widgets = [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    } else {
      _widgets = [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    child: StatCard(
                        title: DateFormat('MMM').format(focusedDay),
                        value: _monthExpenditure())),
                const SizedBox(width: 10),
                Expanded(
                    child: StatCard(
                        title: _getExpenditureText(),
                        value: _getExpenditure())),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        for (var purchase in _getActivePurchases()) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: WPurchase(purchase),
          ),
        ],
        if (_getActivePurchases().isEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UnDraw(
                  height: 100.0,
                  illustration: UnDrawIllustration.empty_cart,
                  color: Colors.grey,
                  useMemCache: true,
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text('No purchases recorded for the highlighted date',
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ]
      ];
    }

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      body: VisibilityDetector(
        key: visibilityKey,
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0) {
            _fetchPurchases(context, focusedDay);
          }
        },
        child: RefreshIndicator(
          onRefresh: () {
            return _fetchPurchases(context, focusedDay);
          },
          child: ListView(
            children: [
              TableCalendar<model.Purchase>(
                headerStyle: const HeaderStyle(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                  ),
                  headerMargin: EdgeInsets.only(bottom: 15.0),
                ),
                calendarStyle: customCalendarStyle,
                rangeSelectionMode: _rangeSelectionMode,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                focusedDay: focusedDay,
                firstDay:
                    DateTime.now().subtract(const Duration(days: 365 * 3)),
                lastDay: DateTime.now(),
                onDaySelected: (selectedDay, focused) {
                  if (!isSameDay(selectedDay, _selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      focusedDay = focused;
                      _rangeStart = null;
                      _rangeEnd = null;
                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(day, _selectedDay);
                },
                onFormatChanged: (format) {
                  setState(() {
                    calendarFormat = format;
                  });
                },
                calendarFormat: calendarFormat,
                onPageChanged: (focused) {
                  focusedDay = focused;
                  _fetchPurchases(context, focused);
                },
                onCalendarCreated: (_) {
                  _fetchPurchases(context, startDate);
                },
                onRangeSelected: (start, end, focused) {
                  setState(() {
                    _selectedDay = null;
                    focusedDay = focused;
                    _rangeStart = start;
                    _rangeEnd = end;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    if (start != null && end != null) {
                      end = DateTime(end!.year, end!.month, end!.day)
                          .add(const Duration(days: 1));
                      _fetchRangePurchases(context, start, end!);
                    }
                  });
                },
                eventLoader: (day) {
                  return _getPurchasesOnDay(day);
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, purchases) {
                    if (purchases.isEmpty) {
                      return null;
                    }
                    var total = 0.0;
                    purchases.forEach((element) => total += element.total!);
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('${formatAmtWithoutDecimal.format(total)}/=',
                          style: const TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.w700)),
                    );
                  },
                ),
              ),
              ..._widgets,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart_outlined),
        onPressed: () {
          Navigator.pushNamed(context, '/new-purchase');
        },
      ),
      bottomNavigationBar: const ClassicBottomNavigation(),
    );
  }

  String _getExpenditureText() {
    var f = DateFormat('EEE, MMM d');
    if (_rangeStart != null && _rangeEnd != null) {
      return '${f.format(_rangeStart!)} to ${f.format(_rangeEnd!)}';
    }
    return f.format(focusedDay);
  }

  Future _fetchPurchases(BuildContext context, DateTime start) {
    var dateRange = _getMonthDateRange(start);
    var client = GraphQLProvider.of(context).value;
    _loading = true;
    return client
        .query(
      QueryOptions(
        document: queries.purchasesQuery,
        variables: {
          "after": model.DateTimeToJson(dateRange[0]),
          "before": model.DateTimeToJson(dateRange[1]),
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    )
        .then((result) {
      if (result.data != null) {
        setState(() {
          purchases = model.Purchases.fromJson(result.data!).purchases;
        });
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  Future _fetchRangePurchases(
      BuildContext context, DateTime start, DateTime end) {
    var client = GraphQLProvider.of(context).value;
    setState(() {
      _loading = true;
    });
    var after = model.DateTimeToJson(start);
    var before = model.DateTimeToJson(end);
    return client
        .query(
      QueryOptions(
        document: queries.purchasesQuery,
        variables: {
          "after": after,
          "before": before,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    )
        .then((result) {
      if (result.data != null) {
        setState(() {
          _rangePurchases = model.Purchases.fromJson(result.data!).purchases;
        });
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  double _totalExpenditure(DateTime? day) {
    if (day == null) {
      return 0;
    }
    var purchases = _getPurchasesOnDay(day);
    double total = 0;

    purchases.forEach((element) {
      total += element.total!;
    });

    return total;
  }

  double _getExpenditure() {
    var total = 0.0;
    if (_rangeOn) {
      for (var p in _rangePurchases) {
        total += p.total!;
      }
      return total;
    }

    return _totalExpenditure(focusedDay);
  }

  bool get _rangeOn {
    return _rangeStart != null && _rangeEnd != null;
  }

  double _monthExpenditure() {
    double total = 0;

    purchases.forEach((element) {
      total += element.total!;
    });

    return total;
  }

  List<model.Purchase> _getPurchasesOnDay(DateTime day) {
    return purchases
        .where((element) => isSameDay(element.date.toLocal(), day))
        .toList();
  }

  List<model.Purchase> _getActivePurchases() {
    if (_rangeStart != null && _rangeEnd != null) {
      return _rangePurchases;
    }
    return _getPurchasesOnDay(focusedDay);
  }
}

List<DateTime> _getMonthDateRange(DateTime start) {
  var year = start.year;
  int month = 1;
  if (start.month < 12) {
    month = start.month + 1;
  } else {
    year += 1;
  }
  var end = DateTime(year, month, 1);

  return [DateTime(start.year, start.month, 1), end];
}
