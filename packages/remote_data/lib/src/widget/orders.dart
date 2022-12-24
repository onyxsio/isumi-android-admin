import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:remote_data/remote_data.dart';
import 'package:remote_data/src/model/order.dart';

class OrderInformation extends StatelessWidget {
  final String id;
  const OrderInformation({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sellers')
          .doc(id)
          .collection('orders')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: HRDots());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: HRDots());
        }

        return ListView(
          padding: EdgeInsets.all(5.w),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Orders order = Orders.fromJson(data);
            return NowOrderListCard(order: order, isClick: true);
          }).toList(),
        );
      },
    );
  }
}
