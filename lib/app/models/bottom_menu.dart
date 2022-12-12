import 'package:isumi/core/utils/utils.dart';

class BottomNaviBar {
  final int id;
  final String image;
  final String name;
  final bool isNotifi;
  BottomNaviBar({
    required this.id,
    required this.image,
    required this.isNotifi,
    required this.name,
  });
}

List<BottomNaviBar> bottomNaviBar = [
  BottomNaviBar(id: 0, image: AppIcon.home, name: 'Home', isNotifi: false),
  BottomNaviBar(id: 1, image: AppIcon.box, name: 'Order', isNotifi: false),
  BottomNaviBar(
      id: 2, image: AppIcon.bell, name: 'Notification', isNotifi: true),
  BottomNaviBar(
      id: 3, image: AppIcon.profile, name: 'Settings', isNotifi: false),
];
