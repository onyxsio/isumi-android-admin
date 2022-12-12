import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';

class ExpandedListDrop extends StatefulWidget {
  const ExpandedListDrop({Key? key}) : super(key: key);

  @override
  State<ExpandedListDrop> createState() => _ExpandedListDropState();
}

class _ExpandedListDropState extends State<ExpandedListDrop>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
//
  var emailController = TextEditingController();
  var phonenoController = TextEditingController();
  var addressController = TextEditingController();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TXTHeader.settingsHeader('Contact information'),
        SizedBox(height: 2.w),
        // listTile(),
        Container(
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
                            'Your profile info in store',
                            style: TxtStyle.header,
                          ),
                          SizedBox(height: 1.w),
                          Text(
                            'This info visible to other people using the Mobile app',
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
                    children: [
                      TextBox(
                        controller: emailController,
                        hintText: 'email',
                        type: TXT.email,
                      ),
                      TextBox(
                        controller: phonenoController,
                        hintText: 'phone',
                        type: TXT.phone,
                      ),
                      TextBox(
                        controller: addressController,
                        hintText: 'address',
                        type: TXT.address,
                      ),
                      MainButton(
                          onTap: () {
                            isShow = !isShow;
                            _runExpandCheck();
                            LocalDB.setEmail(emailController.text);
                            LocalDB.setAddress(addressController.text);
                            LocalDB.setPhone(phonenoController.text);
                            setState(() {});
                          },
                          text: 'Save changes')
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   expandController.dispose();
  //   emailController.dispose();
  //   phonenoController.dispose();
  //   addressController.dispose();
  //   super.dispose();
  // }
}
