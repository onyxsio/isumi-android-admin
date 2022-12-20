import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';

class ExpandedCheckbox extends StatefulWidget {
  const ExpandedCheckbox({Key? key}) : super(key: key);

  @override
  State<ExpandedCheckbox> createState() => _ExpandedCheckboxState();
}

class _ExpandedCheckboxState extends State<ExpandedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
//

  bool isShow = false;
  String text = '';

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
      decoration: BoxDeco.itemSizeCard,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // FocusManager.instance.primaryFocus?.unfocus();
              isShow = !isShow;
              _runExpandCheck();
              setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your selling info',
                        style: TxtStyle.header,
                      ),
                      SizedBox(height: 1.w),
                      Text(
                        'This information is visible to you. You can select the information you want',
                        style: TxtStyle.settingSubtitle,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(
                  isShow
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color: AppColor.yellow,
                  // size: 5.w,
                )
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: ValueListenableBuilder<Box>(
                  valueListenable: HiveDB.sellerBox.listenable(),
                  builder: (context, box, widget) {
                    return Column(
                      children: [
                        SizedBox(height: 5.w),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('sold', p0),
                            text: 'sold',
                            value: HiveDB.sold(box)!),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('unsold', p0),
                            text: 'unsold',
                            value: HiveDB.unsold(box)!),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('outOfStock', p0),
                            text: 'Out Of Stock',
                            value: HiveDB.outOfStock(box)!),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('almostFinished', p0),
                            text: 'Near to out stock',
                            value: HiveDB.almostFinished(box)!),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('todayOrders', p0),
                            text: 'Today\'s orders',
                            value: HiveDB.todayOrders(box)!),
                        CheckBoxButton(
                            onChanged: (p0) => box.put('todayIncome', p0),
                            text: 'Today\'s income',
                            value: HiveDB.todayIncome(box)!),
                        //
                        CheckBoxButton(
                            onChanged: (p0) => box.put('mostSell', p0),
                            text: 'Most Selling',
                            value: HiveDB.mostSell(box)!),
                        //
                        CheckBoxButton(
                            onChanged: (p0) => box.put('totalUsers', p0),
                            text: 'Total Users',
                            value: HiveDB.totalUsers(box)!),
                        SizedBox(height: 5.w),
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}
