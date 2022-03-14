enum AnalyticsFor {
  month,
  dateRange,
}

class AnalyticsForSettings {
  final AnalyticsFor analyticsFor;
  final int? month;
  final DateTime? after;
  final DateTime? before;
  DateTime? _start;
  DateTime? _end;
  bool _calculated = false;

  AnalyticsForSettings(
      {required this.analyticsFor, this.month, this.after, this.before});

  DateTime get start {
    if (_start != null) return _start!;
    _calculate();
    return _start!;
  }

  DateTime get end {
    if (_end != null) return _end!;
    _calculate();
    return _end!;
  }

  void _calculate() {
    if (_calculated) return;
    switch (analyticsFor) {
      case AnalyticsFor.month:
        _start = DateTime(DateTime.now().year, month!, 1);
        var _month = month == 12 ? 1 : month! + 1;
        var _year = month == 12 ? DateTime.now().year + 1 : DateTime.now().year;
        _end = DateTime(_year, _month, 1);
        _calculated = true;
        break;
      case AnalyticsFor.dateRange:
        _start = DateTime(after!.year, after!.month, after!.day);
        _end = before?.add(const Duration(days: 1)) ??
            _start?.add(const Duration(days: 1));
        _end = DateTime(_end!.year, _end!.month, _end!.day);
        _calculated = true;
        break;
    }
  }
}
