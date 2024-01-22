class Statistic {
  final String statisticName;
  final String statisticBirim;
  final int statisticNewCount;
  final int statisticOldCount;
  
  Statistic(
      {required this.statisticName,
      required this.statisticBirim,
      required this.statisticNewCount,
      required this.statisticOldCount});
  static List<Statistic> staticLists = [
    Statistic(
        statisticName: 'Toplam Elde Edilen',
        statisticBirim: '₺',
        statisticNewCount: 1234,
        statisticOldCount: 1100),
    Statistic(
        statisticName: 'Toplam Kazanç',
        statisticBirim: '₺',
        statisticNewCount: 346,
        statisticOldCount: 1100),
    Statistic(
        statisticName: 'Sipariş Sayısı',
        statisticBirim: 'Kutu',
        statisticNewCount: 6,
        statisticOldCount: 8),
    Statistic(
        statisticName: 'Kargoyu Bekleyen',
        statisticBirim: 'Kutu',
        statisticNewCount: 1234,
        statisticOldCount: 1100)
  ];

  static double calculateDiffrence(Statistic statistic) {
    return (statistic.statisticNewCount - statistic.statisticOldCount) /
        statistic.statisticOldCount *
        100;
  }
}
