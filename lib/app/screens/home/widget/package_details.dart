import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class PackageDetails extends StatefulWidget {
  const PackageDetails({Key? key, required this.packageFun, this.package})
      : super(key: key);
  final Function(Package) packageFun;
  final Package? package;
  @override
  State<PackageDetails> createState() => _ExpandedListDropState();
}

class _ExpandedListDropState extends State<PackageDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  //

//
  var lengthController = TextEditingController();
  var weightValue = TextEditingController();
  var widthController = TextEditingController();
  var heightController = TextEditingController();
//

  bool isShow = false;
  String weightText = 'Unit';

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
    setupData();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  void setupData() {
    if (widget.package != null) {
      setState(() {
        lengthController.text = widget.package!.dimensions!.length!;
        widthController.text = widget.package!.dimensions!.width!;
        heightController.text = widget.package!.dimensions!.height!;
        weightText = widget.package!.weight!.unit!;
        weightValue.text = widget.package!.weight!.value!;
      });
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
                      TXTHeader.header2('Package details'),
                      SizedBox(height: 1.w),
                      Text(
                        'Enter package details here, including weight, height and length',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.w),
                  TXTHeader.settingsHeader('Weight'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectDropList(
                          (optionItem) {
                            setState(() => weightText = optionItem);
                          },
                          weightUnitList,
                          selectOption: weightText,
                          // title: "Unit",
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: TextBox(
                          controller: weightValue,
                          hintText: 'Value',
                          type: TXT.deliveryPrice,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 5.w),
                  TXTHeader.settingsHeader('Dimensions (centimeter - cm)'),
                  // SizedBox(height: 5.w),

                  Row(
                    children: [
                      Expanded(
                        child: TextBox(
                          controller: lengthController,
                          hintText: 'length',
                          type: TXT.deliveryPrice,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextBox(
                          controller: widthController,
                          hintText: 'width',
                          type: TXT.deliveryPrice,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextBox(
                          controller: heightController,
                          hintText: 'height',
                          type: TXT.deliveryPrice,
                        ),
                      ),
                    ],
                  ),
                  MainButton(
                      onTap: () {
                        Package package = Package(
                            weight: Weight(
                              unit: weightText,
                              value: weightValue.text,
                            ),
                            dimensions: Dimensions(
                              height: heightController.text,
                              width: widthController.text,
                              length: lengthController.text,
                              unit: 'cm',
                            ));
                        isShow = !isShow;
                        _runExpandCheck();
                        widget.packageFun(package);
                        setState(() {});
                      },
                      text: 'Save changes')
                ],
              )),
        ],
      ),
    );
  }
}
