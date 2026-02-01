enum DeliveryAnalyticsTimeRangeEnum {
  today('today'),
  thisWeek('this_week'),
  thisMonth('this_month'),
  thisYear('this_year'),
  allTime('all_time');

  final String name;
  const DeliveryAnalyticsTimeRangeEnum(this.name);
}