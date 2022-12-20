// import 'package:onyxsio/onyxsio.dart';

// ignore_for_file: depend_on_referenced_packages

import 'package:local_database/local_db.dart';
import 'package:remote_data/remote_data.dart';
import 'package:splashpage/splashpage.dart';

class Onyxsio {
  static init() async {
    // Initialize the Splash Screen
    await SplashScreen.init();
    // Initialize the Firebase app
    await FirebaseService.init();
    // Initialize the Hive Local Database
    await HiveDB.init();
    // SQFL
    await SQFLiteDB.database;
  }
}
