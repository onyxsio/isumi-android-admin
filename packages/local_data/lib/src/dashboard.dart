import 'package:hive/hive.dart';

part 'dashboard.g.dart';

@HiveType(typeId: 1)
class DashboardCompo extends HiveObject {
  @HiveField(0)
  final bool outOfStock;

  @HiveField(1)
  final bool sold;

  @HiveField(2)
  final bool unsold;
  @HiveField(3)
  final bool almostFinished;

  @HiveField(4)
  final bool mostSell;

  @HiveField(5)
  final bool todayOrders;
  @HiveField(6)
  final bool todayIncome;

  @HiveField(7)
  final bool totalUsers;

  DashboardCompo(this.outOfStock, this.sold, this.unsold, this.almostFinished,
      this.mostSell, this.todayOrders, this.todayIncome, this.totalUsers);
}
