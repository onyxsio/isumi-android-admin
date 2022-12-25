import 'package:onyxsio/onyxsio.dart';
import 'package:firebase_core/firebase_core.dart';
export 'repository/auth.dart';
export 'repository/firestore.dart';
export 'repository/storage.dart';
export 'notification/message.dart';

class FirebaseService {
  static Future<void> init() async {
    // Initialize the Firebase app
    await Firebase.initializeApp();
    // Initialize the Notification Service
    await NotificationService.initializeFirebase();
    //
    await FireRepo().setupDeviceToken();
    //
    // await FirestoreRepository().setupDashboard(emptyDash);
    // final authRepo = AuthRepository();
    // await authRepo.user.first;
  }
}
