import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:isumi/app/models/route.dart';
import '../../util/util.dart';
import 'package:remote_data/remote_data.dart';

class NowOrderListCard extends StatelessWidget {
  final Orders order;
  final bool isClick;
  const NowOrderListCard({Key? key, required this.isClick, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OrderData data = OrderData(isNow: isClick, order: order);
        Navigator.pushNamed(context, '/OrderDetails', arguments: data);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(vertical: 3.w),
        decoration: BoxDeco.overview,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text('Order No: #${Utils.orderNumber(order.sId!)}',
                        maxLines: 1, style: TxtStyle.b5B)),
              ],
            ),
            const Divider(),
            SizedBox(height: 2.w),
            Text(Utils.date(order.date!), style: TxtStyle.h4L),
            SizedBox(height: 2.w),
            Row(
              children: [
                Text('To:', style: TxtStyle.b5B),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    '${order.customer!.address!.streetAddress!} ${order.customer!.address!.city} ${order.customer!.address!.postalCode}',
                    style: TxtStyle.b3,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
