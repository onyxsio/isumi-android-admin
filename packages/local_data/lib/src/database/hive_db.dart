import 'package:hive_flutter/hive_flutter.dart';

class HiveDB {
  static late Box<String> box;
  static late Box<bool> sellerBox;
  //
  static init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('localdata');
    sellerBox = await Hive.openBox<bool>('sellerBox');
  }

  static String? getCurrency = box.get('currency', defaultValue: 'JPY');

  static setCurrency({required String data}) => box.put('currency', data);

  // static close() {
  //   box.close();
  // }

  // static setName(String data) => box.put('Name', data);
  // static String? getName(Box box) => box.get('Name', defaultValue: '');
  // static setSlogan(String data) => box.put('slogan', data);
  // static String? getSlogan(Box box) => box.get('slogan', defaultValue: '');
  // static setEmail(String data) => box.put('Email', data);
  // static String? getEmail(Box box) => box.get('Email', defaultValue: '');

  // static setPhone(String data) => box.put('Phon', data);
  // static String? getPhone(Box box) => box.get('Phon', defaultValue: '');

  // static setAddress(String data) => box.put('Address', data);
  // static String? getAddress(Box box) => box.get('Address', defaultValue: '');

  //
  static bool? outOfStock(Box box) =>
      box.get('outOfStock', defaultValue: false);
  //
  static bool? sold(Box box) => box.get('sold', defaultValue: false);
  //
  static bool? unsold(Box box) => box.get('unsold', defaultValue: false);
  //
  static bool? almostFinished(Box box) =>
      box.get('almostFinished', defaultValue: false);
  //
  static bool? mostSell(Box box) => box.get('mostSell', defaultValue: false);
  //
  static bool? todayOrders(Box box) =>
      box.get('todayOrders', defaultValue: false);
  //
  static bool? todayIncome(Box box) =>
      box.get('todayIncome', defaultValue: false);
  //
  static bool? totalUsers(Box box) =>
      box.get('totalUsers', defaultValue: false);
}
