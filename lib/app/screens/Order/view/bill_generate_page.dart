import 'package:flutter/material.dart';
import 'package:isumi/app/screens/Order/widgets/uniq_id.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class GenerateBill extends StatefulWidget {
  final Orders order;
  const GenerateBill({Key? key, required this.order}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

class _GenerateBillState extends State<GenerateBill> {
  bool isLoading = false;
  late Admin admin;
  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  Future<void> getAdminData() async {
    setState(() => isLoading = true);
    admin = await SQFLiteDB.readOne();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: appBar(text: 'Accept an Order'),
      body: isLoading ? const Center(child: HRDots()) : _buildBody(),
      bottomNavigationBar: bottomNavigationBar(
        text: 'Generate the bill',
        onTap: () async {
          // var seller = await FirestoreRepository.getSeller(user.id);
          // TODO Pass the seller data
          final pdfFile = await PdfInvoiceApi.generate(widget.order, admin);
          // opening the pdf file
          FileHandleApi.openFile(pdfFile);
        },
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(AppImage.logo, width: 12.w, height: 12.w),
              SizedBox(width: 2.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(admin.name, style: TxtStyle.b5B),
                  Text(
                    admin.slogan,
                    style: TxtStyle.b1.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                  flex: 3, child: Container(height: 5.w, color: Colors.yellow)),
              SizedBox(width: 2.w),
              Text('INVOICE', style: TxtStyle.b5B),
              SizedBox(width: 2.w),
              Expanded(child: Container(height: 5.w, color: Colors.yellow)),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice To:', style: TxtStyle.b5B),
                  SizedBox(height: 0.5.h),
                  Text(widget.order.customer!.address!.name!,
                      style: TxtStyle.b3B),
                  SizedBox(
                    width: 35.w,
                    child: Text(
                        '${widget.order.customer!.address!.streetAddress!} ${widget.order.customer!.address!.city}\n${widget.order.customer!.address!.postalCode}',
                        style: TxtStyle.b3),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invoice:', style: TxtStyle.b3B),
                        SizedBox(height: 1.w),
                        Text('Date:', style: TxtStyle.b3B),
                      ],
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(GUIDGen.generate(), style: TxtStyle.b3),
                        SizedBox(height: 1.w),
                        Text(Utils.formatDate(DateTime.now()),
                            style: TxtStyle.b3),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          const Divider(),
          SizedBox(height: 2.h),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(2),
            },
            border: TableBorder.symmetric(
                outside: BorderSide(width: 0.5, color: AppColor.gray1)),
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
                      child: SizedBox(
                        height: 10.w,
                        child: Center(
                          child: Text('No:', style: TxtStyle.b3B),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text('Item', style: TxtStyle.b3B),
                    ),
                    TableCell(
                      child: Text('Price', style: TxtStyle.b3B),
                    ),
                    TableCell(
                      child: Text('Qty', style: TxtStyle.b3B),
                    ),
                    TableCell(
                      child: Center(child: Text('Total', style: TxtStyle.b3B)),
                    ),
                  ]),
              for (int i = 0; i < widget.order.items!.length; i++)
                TableRow(
                  children: [
                    TableCell(
                      child: SizedBox(
                        height: 7.w,
                        child: Center(
                            child: Text('${i + 1}', style: TxtStyle.b3B)),
                      ),
                    ),
                    TableCell(
                      child: Text(widget.order.items![i].name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TxtStyle.b3),
                    ),
                    TableCell(
                      child: Text(widget.order.items![i].price!,
                          style: TxtStyle.b3),
                    ),
                    TableCell(
                      child: Text(widget.order.items![i].quantity!,
                          style: TxtStyle.b3),
                    ),
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              Utils.currencySymble(
                                  name: widget.order.currency!),
                              style: TxtStyle.b1),
                          SizedBox(width: 1.w),
                          Text(totalPrice(widget.order.items![i]),
                              style: TxtStyle.b3B),
                          SizedBox(width: 5.w),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 1.h),
          // const Divider(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Container(height: 1, color: Colors.grey),
                    SizedBox(height: 1.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sub Total:', style: TxtStyle.b3B),
                            SizedBox(height: 2.w),
                            Text('Tax:', style: TxtStyle.b3B),
                          ],
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                    Utils.currencySymble(
                                        name: widget.order.currency!),
                                    style: TxtStyle.b1),
                                SizedBox(width: 1.w),
                                Text(widget.order.total!, style: TxtStyle.b3),
                              ],
                            ),
                            SizedBox(height: 2.w),
                            Text('0.0%', style: TxtStyle.b3),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Container(height: 1, color: Colors.grey)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child:
                    Text('Thank you for your purchase!', style: TxtStyle.b3B),
              ),
              Container(
                height: 8.w,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                color: Colors.yellow,
                child: Row(
                  children: [
                    Text('Total:', style: TxtStyle.b5B),
                    SizedBox(width: 2.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(Utils.currencySymble(name: widget.order.currency!),
                            style: TxtStyle.b4),
                        SizedBox(width: 1.w),
                        Text(widget.order.total!, style: TxtStyle.b6B),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                    'Scan the QR code with your phone camera to provide feedback on your experience.',
                    textAlign: TextAlign.center,
                    style: TxtStyle.b3),
              ),
              Image.asset(AppImage.demoQrcode, width: 15.w, height: 15.w),
            ],
          ),
          SizedBox(height: 1.h),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(admin.phone, style: TxtStyle.b3),
              Text(admin.email, style: TxtStyle.b3),
            ],
          )
        ],
      ),
    );
  }

  String totalPrice(Items item) {
    return Utils.value(
        amount: (int.parse(item.quantity!) * double.parse(item.price!)),
        name: item.currency);
  }

  String unitPrice(Items item) {
    return Utils.currency(
        amount: double.parse(item.price!), name: item.currency);
  }
}
