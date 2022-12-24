import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:remote_data/src/model/models.dart';

class DashboardInformation extends StatelessWidget {
  final String id;
  final Widget Function(Seller) child;
  const DashboardInformation({Key? key, required this.child, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = context.select((AppBloc bloc) => bloc.state.user);
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('sellers').doc(id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: HRDots());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: HRDots());
        }
        // var f1 = snapshot.data!.docs.first.data();
        if (snapshot.data != null) {
          Seller f1 = Seller.fromJsonFirebase(snapshot.data);
          return child.call(f1);
        }
        return const SizedBox();
      },
    );
  }
}
