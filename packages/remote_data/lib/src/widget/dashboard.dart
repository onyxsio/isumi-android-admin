import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:remote_data/src/model/models.dart';

class DashboardInformation extends StatelessWidget {
  // final Widget child; //Dashboard,
  final Widget Function(Seller) child;
  const DashboardInformation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('seller')
          .doc('overview')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        }
        // var f1 = snapshot.data!.docs.first.data();
        Seller f1 = Seller.fromJsonFirebase(snapshot.data);

        return child.call(f1);
      },
    );
  }
}
