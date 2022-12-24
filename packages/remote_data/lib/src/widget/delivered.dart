import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:components/util/util.dart';
import 'package:flutter/material.dart';
import 'package:remote_data/remote_data.dart';

class DeliveredInformation extends StatelessWidget {
  final String id;
  const DeliveredInformation({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sellers')
          .doc(id)
          .collection('delivered')
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
            return FocusedMenuHolder(
                menuContent: menuContent(index: document.id, context: context),
                child: NowOrderListCard(order: order, isClick: false));
          }).toList(),
        );
      },
    );
  }

  Padding menuContent({required index, context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: InkWell(
          onTap: () async {
            await FirestoreRepository.deleteDelivery(index, id);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(AppCIcon.trash, color: AppColor.error),
              SizedBox(width: 2.w),
              Text('Delete', style: TxtStyle.itemDelete),
            ],
          )),
    );
  }
}
