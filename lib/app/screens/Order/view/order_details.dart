import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class OrderDetails extends StatelessWidget {
  final Orders order;
  const OrderDetails({Key? key, required this.order}) : super(key: key);

  String priceCalsulate() {
    // var tot = (double.parse(order.total!) + double.parse(order.delivery!)) -
    //     double.parse(order.discountedPrice!);
    return Utils.value(
        amount: double.parse(order.total!), name: order.currency);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: appBar(text: 'Order details'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 6.w).copyWith(top: 5.w),
        child: Column(
          children: [
            _tileBackground([
              priceTag('Items Total', order.total!),
              SizedBox(height: 3.w),
              priceTag('Delivery charges', order.delivery!),
              SizedBox(height: 3.w),
              priceTag('Discount', order.discountedPrice!),
              SizedBox(height: 3.w),
              const Divider(),
              SizedBox(height: 3.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Amount', style: TxtStyle.header),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Utils.currencySymble(name: order.currency),
                          style: TxtStyle.l1B),
                      SizedBox(width: 2.w),
                      Text(priceCalsulate(),
                          style: TxtStyle.h11.copyWith(height: 0.5)),
                    ],
                  ),
                ],
              ),
            ], 'Price details'),
            _tileBackground(
                order.items!.map((e) => _buildProductTile(e)).toList(),
                'Product details'),
            _tileBackground([
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: Text('Name: ', style: TxtStyle.l3B)),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 3,
                    child: Text(order.customer!.address!.name!,
                        style: TxtStyle.l3),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1, child: Text('Address:', style: TxtStyle.l3B)),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${order.customer!.address!.streetAddress!} ${order.customer!.address!.city} ${order.customer!.address!.postalCode}',
                      style: TxtStyle.l3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              if (order.customer!.phoneNumber != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1, child: Text('Phone :', style: TxtStyle.l3B)),
                    SizedBox(width: 2.w),
                    Expanded(
                      flex: 3,
                      child: Text(order.customer!.phoneNumber!,
                          style: TxtStyle.l3),
                    ),
                  ],
                ),
              SizedBox(height: 3.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1, child: Text('Email :', style: TxtStyle.l3B)),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 3,
                    child: Text(order.customer!.email!, style: TxtStyle.l3),
                  ),
                ],
              ),
            ], 'Shipping details'),
            SizedBox(height: 5.w),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        text: 'Accept an Order',
        onTap: () async {
          FirestoreRepository.orderMoveToDelivered(order, user.id);
          Navigator.pushNamed(context, '/GenerateBill', arguments: order);
        },
      ),
    );
  }

  Column _buildProductTile(Items item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product :',
          style: TxtStyle.b5B,
        ),
        SizedBox(height: 3.w),
        Text(item.name!, style: TxtStyle.reviews),
        SizedBox(height: 3.w),
        Table(
          border: TableBorder.symmetric(
              outside: BorderSide(width: 0.5, color: AppColor.divider)),
          children: [
            TableRow(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.02),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    )),
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: SizedBox(
                      height: 8.w,
                      child: Center(
                        child: Text(
                          'Size',
                          textAlign: TextAlign.center,
                          style: TxtStyle.reviews,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(
                      'Quantity',
                      textAlign: TextAlign.center,
                      style: TxtStyle.reviews,
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text(
                      'Color',
                      textAlign: TextAlign.center,
                      style: TxtStyle.reviews,
                    ),
                  ),
                ]),
            // for (int o = 0; o < item.variants!.length; o++)
            // for (int j = 0; j < item.variants![o].subvariants!.length; j++)
            TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: SizedBox(
                    height: 10.w,
                    child: Center(
                      child: Text('${item.size}',
                          textAlign: TextAlign.center, style: TxtStyle.b5B),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Text('${item.quantity}',
                      textAlign: TextAlign.center, style: TxtStyle.header),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Container(
                    height: 7.w,
                    width: 7.w,
                    // margin: EdgeInsets.only(top: 2.w),
                    decoration: BoxDecoration(
                      // color: Colors.red.withOpacity(0.2),
                      color: Color(int.parse(item.color!)),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 5.w),
      ],
    );
  }

  Row priceTag(String title, String cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TxtStyle.settinSubTitle,
        ),
        Row(
          children: [
            Text(Utils.currencySymble(name: order.currency),
                style: TxtStyle.l1B),
            SizedBox(width: 1.w),
            Text(
                Utils.value(
                  amount: double.parse(cost),
                  name: order.currency,
                ),
                style: TxtStyle.header),
          ],
        ),
      ],
    );
  }

  Container _tileBackground(List<Widget> children, String title) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 3.w),
      decoration: BoxDeco.overview,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TxtStyle.header),
          const Divider(),
          const SizedBox(height: 10),
          ...children,
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
