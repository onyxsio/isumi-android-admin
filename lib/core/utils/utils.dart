import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isumi/app/screens/Notification/view/notification_page.dart';
import 'package:isumi/app/screens/Order/view/order_page.dart';
import 'package:isumi/app/screens/Settings/view/settings_page.dart';
import 'package:isumi/app/screens/home/home.dart';
import 'package:onyxsio/onyxsio.dart';

class AppImage {
  static const String logo = 'assets/images/logo.png';
  static const String demoQrcode = 'assets/images/qrcode.png';
}

class AppIcon {
  static const String password = 'assets/icons/eye.svg';
  static const String edit = 'assets/icons/edit.svg';
  static const String add = 'assets/icons/add.svg';
  static const String box = 'assets/icons/box.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String cart = 'assets/icons/cart.svg';
  static const String home = 'assets/icons/home.svg';
  static const String location = 'assets/icons/location.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String search = 'assets/icons/search.svg';
  static const String trash = 'assets/icons/trash.svg';
  static const String logout = 'assets/icons/logout.svg';
  static const String done = 'assets/icons/done.svg';
  static const String erorr = 'assets/icons/erorr.svg';
  static const String camera = 'assets/icons/camera.svg';
  static const String plus = 'assets/icons/plus.svg';
  static const String oops = 'assets/icons/oops.svg';
  static const String wifi = 'assets/icons/wifi.svg';
  static const String save = 'assets/icons/save.svg';
  //
  static const String product = 'assets/icons/product.svg';
  static const String offer = 'assets/icons/offer.svg';
  static const String message = 'assets/icons/message.svg';

  static const String dress = 'assets/icons/dress.svg';
  static const String google = 'assets/icons/google.svg';
}
//

List<Widget> mainPages = [
  const HomePage(),
  const OrderPage(),
  const NotificationPage(),
  const SettingsPage(),
  // Container(color: Colors.red),
  // Container(color: Colors.blue),
];

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static formatDateTime(DateTime date) =>
      DateFormat('yyyy-M-d hh:mm:ss').format(date);

  static formatCurrencySymble({name}) =>
      NumberFormat.simpleCurrency(name: name).currencySymbol;

  static formatCurrency({name, amount}) => CurrencyFormat.simpleCurrency(
        locale: Platform.localeName,
        name: name,
        customPattern: '#,###', //\u00a4
      ).format(amount);

  static currency({name, amount}) => CurrencyFormat.simpleCurrency(
        locale: Platform.localeName,
        name: name,
        customPattern: '\u00a4 #,###', //
      ).format(amount);

  static offerCal({name, amount, offer}) {
    var cal = ((double.parse(amount) * double.parse(offer)) / 100);

    return currency(amount: (double.parse(amount) - cal), name: name);
  }
}

List<String> currencyList = ["USD", "JPY", "LKR"];
List<String> weightUnitList = ["kg", "g", "oz", 'lbs'];
