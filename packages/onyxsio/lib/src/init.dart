// import 'package:onyxsio/onyxsio.dart';

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
    await LocalDB.init();
  }
}
