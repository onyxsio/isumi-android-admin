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
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var sloganController = TextEditingController();
//

  bool isShow = false;
  bool isLoading = false;
  String text = '';
  late Admin admin;
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
    getData();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  Future<void> getData() async {
    setState(() => isLoading = true);
    // await SQFLiteDB.create();
    admin = await SQFLiteDB.readOne();
    await setupData();
    setState(() => isLoading = false);
  }

  Future<void> setupData() async {
    if (!mounted) return;
    setState(() {
      nameController.text = admin.name;
      emailController.text = admin.email;
      addressController.text = admin.address;
      phonenoController.text = admin.phone;
      sloganController.text = admin.slogan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: HRDots())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TXTHeader.settingsHeader('Contact information'),
              SizedBox(height: 2.w),
              // listTile(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
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
                              controller: nameController,
                              hintText: 'name',
                              type: TXT.text,
                            ),
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
                            TextBox(
                              controller: sloganController,
                              hintText: 'slogan',
                              type: TXT.text,
                            ),
                            MainButton(onTap: update, text: 'Save changes')
                          ],
                        )),
                  ],
                ),
              ),
            ],
          );
  }

  void update() async {
    Admin adminData = Admin(
      id: 0,
      email: emailController.text,
      phone: phonenoController.text,
      name: nameController.text,
      slogan: sloganController.text,
      address: addressController.text,
    );
    await SQFLiteDB.update(adminData).then((value) {
      if (value) {
        isShow = !isShow;
        _runExpandCheck();
        DBox.autoClose(context,
            type: InfoDialog.successful,
            message: 'The Data has been saved successfully.');
        setState(() {});
      } else {
        DBox.autoClose(context,
            type: InfoDialog.error, message: 'An unknown exception occurred.');
      }
    });
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
