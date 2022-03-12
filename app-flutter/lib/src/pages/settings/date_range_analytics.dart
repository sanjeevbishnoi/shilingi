enum AnalyticsFor {
  month,
  dateRange,
}

class AnalyticsForSettings {
  final AnalyticsFor analyticsFor;
  final int? month;
  final DateTime? after;
  final DateTime? before;

  const AnalyticsForSettings(
      {required this.analyticsFor, this.month, this.after, this.before});
}
