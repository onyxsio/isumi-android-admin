import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:isumi/app/screens/Settings/widgets/expanded_checkbox.dart';
import 'package:isumi/app/screens/Settings/widgets/expanded_list.dart';
import 'package:isumi/app/screens/Settings/widgets/pic_bg.dart';
import 'package:isumi/app/screens/Settings/widgets/settings_tile.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Uint8List? _image;
  bool switchValue = true;

  //
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    if (mounted) {
      setState(() => _image = im);
    }
  }

  @override
  Widget build(BuildContext context) {
    // currency = context.watch<AppCurrency>().currency;
    return Scaffold(
      appBar: mainAppBar(text: 'Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(top: 5.w),
        physics: const BouncingScrollPhysics(),
        child: ValueListenableBuilder<Box>(
            valueListenable: HiveDB.box.listenable(),
            builder: (context, box, widget) {
              var currency = box.get('currency');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    width: double.infinity,
                    decoration: BoxDeco.overview,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload an image', style: TxtStyle.itemUpdate),
                        SizedBox(height: 5.w),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 7.h,
                                  backgroundColor: AppColor.black2,
                                ),
                                _image != null
                                    ? CircleAvatar(
                                        radius: 7.h,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: 6.h,
                                        backgroundColor: AppColor.black2,
                                        child: Image.asset(AppImage.logo,
                                            fit: BoxFit.cover)),
                                // TODO upload image to firebase
                                // : CachedNetworkImage(
                                //     imageUrl:
                                //         "https://i.stack.imgur.com/l60Hf.png",
                                //     imageBuilder: (context,
                                //             imageProvider) =>
                                //         CircleAvatar(
                                //             radius: 7.h,
                                //             backgroundImage: imageProvider),
                                //     placeholder: (context, url) =>
                                //         CircleAvatar(radius: 7.h),
                                //     errorWidget: (context, url, error) =>
                                //         const Icon(Icons.error),
                                //   ),
                                CustomPaint(
                                  painter: MyPainter(),
                                  size: Size(7.h, 7.h),
                                ),
                                Positioned(
                                  top: 10.h,
                                  child: InkWell(
                                    onTap: selectImage,
                                    child: SvgPicture.asset(
                                      AppIcon.camera,
                                      color: AppColor.white,
                                      height: 5.w,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              // width: 50.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('It\'s used as your Store logo.',
                                      style: TxtStyle.l2),
                                  SizedBox(height: 2.w),
                                  Text('photo measures 100px by 100px.',
                                      style: TxtStyle.l2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.w),
                  // TODO
                  SettingsTile(
                    title: 'Temporary Closure',
                    subtitle:
                        'Notice customers of a temporary closure of the shop with stated reasons. ',
                    switchValue: switchValue,
                    onChanged: (bool? value) {
                      setState(() {
                        switchValue = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 5.w),
                  SelectDropList(
                    (optionItem) {
                      setState(() {
                        currency = optionItem;
                        HiveDB.setCurrency(data: optionItem);
                      });
                      // getLocalData();
                    },
                    currencyList,
                    selectOption: currency,
                    title: "Select product currency",
                  ),
                  SizedBox(height: 5.w),
                  const ExpandedListDrop(),
                  SizedBox(height: 3.w),
                  TXTHeader.settingsHeader('General'),
                  SizedBox(height: 3.w),
                  const ExpandedCheckbox(),
                  SettingsTile(
                    title: 'Theme',
                    subtitle: 'There is a dark or light theme to change',
                    switchValue: switchValue,
                    onChanged: (bool? value) {
                      setState(() {
                        switchValue = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 5.w),
                  // Container(
                  //   padding: EdgeInsets.all(4.w),
                  //   decoration: BoxDecoration(
                  //     color: whiteColor,
                  //     boxShadow: [blackColorShadow],
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: 5.w),
                  //       listTile(
                  //         title: 'Shipping Addresses',
                  //         subTitle: '03 Addresses',
                  //         onTap: () {
                  //           Navigator.pushNamed(context, '/ShippingAddressPage');
                  //         },
                  //       ),
                  //       const Divider(),
                  //       SizedBox(height: 5.w),
                  //       listTile(
                  //         title: 'Payment Method',
                  //         subTitle: 'You have 2 cards',
                  //         onTap: () {
                  //           Navigator.pushNamed(context, '/PaymetMethodPage');
                  //         },
                  //       ),
                  //       const Divider(),
                  //       SizedBox(height: 5.w),
                  //       listTile(
                  //         title: 'My reviews',
                  //         subTitle: 'Reviews for 5 items',
                  //         onTap: () {
                  //           Navigator.pushNamed(context, '/ReviewPage');
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              );
            }),
      ),
    );
  }

  Widget listTile({
    required String title,
    required String subTitle,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TxtStyle.header,
                ),
                SizedBox(height: 1.w),
                Text(
                  subTitle,
                  style: TxtStyle.settinSubTitle,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor.yellow,
              size: 5.w,
            )
          ],
        ),
      ),
    );
  }
}
