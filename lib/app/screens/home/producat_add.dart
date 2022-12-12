import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

import 'producat_add_veriant.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({Key? key}) : super(key: key);

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  // Create Text Editing Controller
  var pName = TextEditingController();
  var pPrice = TextEditingController();
  var pQuantity = TextEditingController();
  var pDescription = TextEditingController();
  var pDiscount = TextEditingController();
  var pDelivery = TextEditingController();
  var pDays = TextEditingController();

  // Create some values

  String pickerColor = '0xffFF7B2C';
  String currentColor = '0xffFF7B2C';
  // Create Option Item List
  String productSize = '', pCurrency = '', category = '', pType = '';
  double lastPrice = 0.0;
  // Create image Picker
  final ImagePicker imagePicker = ImagePicker();
  // Create List for XFile image
  List<XFile>? imageFileList = [];
  List<Variant> productVariantList = [];
  // var map2 = {};
  // var map1 = [];
  // var seen = Set();
  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color.value.toString());
  }

  void getSubVariant() async {
    List<Variant>? persons = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductVeriantAddPage(),
      ),
    );

    if (persons != null) {
      setState(() => productVariantList.addAll(persons));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final formvalidation = Provider.of<ValidationProvider>(context);
    final formvalidation = context.watch<Validation>().isvalid;
    return Scaffold(
      appBar: ternaryAppBar(text: "Let’s add a new product"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.w),
            TXTHeader.header2("Product name"),
            TextBox(type: TXT.name, controller: pName),
            TXTHeader.header2("Product description"),
            TextBox(type: TXT.description, controller: pDescription),
            TXTHeader.header2("Product images"),
            SizedBox(height: 5.w),
            if (imageFileList!.isNotEmpty) _buildImageGrid(),
            const Divider(),
            SizedBox(height: 5.w),
            ImageButton(
                onTap: selectImages,
                image: AppIcon.camera,
                text: 'Select Images'),
            SizedBox(height: 5.w),
            TXTHeader.header2("Create Different variants "),
            SizedBox(height: 5.w),
            if (productVariantList.isNotEmpty) _buildSizeColorQtyGrid(),
            const Divider(),
            ImageButton(
                onTap: getSubVariant,
                image: AppIcon.dress,
                text: 'Product Variants'),
            SizedBox(height: 5.w),
            CheckBoxDrop(
              type: TXT.discountPrice,
              controller: pDiscount,
              onOptionSelected: (optionItem) {
                setState(() => pCurrency = optionItem);
              },
              title: 'Is there a price reduction?',
            ),
            CheckBoxDrop(
              type: TXT.deliveryPrice,
              controller: pDelivery,
              onOptionSelected: (optionItem) {
                setState(() => pCurrency = optionItem);
              },
              title: 'Is there free delivery?',
            ),
            CheckBoxDrop(
              type: TXT.returnDays,
              controller: pDays,
              prefex: false,
              title: 'Is there a return?',
            ),
            SizedBox(height: 5.w),
            // SelectDropList(
            //   (optionItem) {
            //     setState(() => category = optionItem);
            //   },
            //   categoryGender,
            //   title: "Select Product Category",
            // ),
            SizedBox(height: 5.w),
            // SelectDropList(
            //   (optionItem) {
            //     setState(() => pType = optionItem);
            //   },
            //   categoryGarment,
            //   title: "Select Product Type",
            // ),
            SizedBox(height: 5.w),
            MainButton(
                onTap: () {
                  if (formvalidation) {
                    if (isAllNotempty()) {
                      productUpload();
                    }
                  } else {}
                },
                text: 'Upload')
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isAllNotempty() {
    // print(pType.isEmpty);
    if (productVariantList.isEmpty || imageFileList == null) {
      return false;
    } else {
      return true;
    }
  }

  void productUpload() async {
    if (productVariantList.isNotEmpty && imageFileList != null) {
      Product product = Product(
        title: pName.text,
        description: pDescription.text,
        variant: productVariantList,
        // images: imageFileList!,
        // delivery: pDelivery.text,
        // returnDays: pDays.text,
        // discount: pDiscount.text,
        // category: category,
        // type: pType,
        // price: lastPrice,
        // details: seen.toList(),
        // currency: pCurrency
      );

      await FirestoreRepository.addProduct(context, product, imageFileList);
      // if (resulte == 'success') {
      // showAutoCloseDialog(context, 'success', 'done');
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   '/MainPage',
      //   (route) => false,
      // );
      // Navigator.pop(context);
      // }
    } else {
      // showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

//
  GridView _buildSizeColorQtyGrid() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: productVariantList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8, crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _buildSizeColorQtyGridTile(index);
        });
  }

//
//
  FocusedMenuHolder _buildSizeColorQtyGridTile(int index) {
    return FocusedMenuHolder(
      menuContent:
          menuContent(index: productVariantList[index], isImage: false),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDeco.itemSizeCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                AppIcon.dress,
                height: 50,
                color: Color(int.parse(productVariantList[index].color!)),
              ),
              Text(
                'variant : ${productVariantList[index].subvariant!.length}',
                // style: TextStyles.b1,
                // TODO
              ),
            ],
          ),
        ),
      ),
    );
  }

//
  GridView _buildImageGrid() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageFileList!.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _buildImageGridTile(index);
        });
  }

  //

//
  FocusedMenuHolder _buildImageGridTile(int index) {
    return FocusedMenuHolder(
      menuContent: menuContent(index: imageFileList![index]),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Image.file(
          File(imageFileList![index].path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void selectImages() async {
    List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(selectedImages);
      });
    }
  }

  Padding menuContent({required index, isImage = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: GestureDetector(
          onTap: () {
            if (isImage) {
              setState(() => imageFileList!.remove(index));
            } else {
              setState(() => productVariantList.remove(index));
            }

            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(AppIcon.trash, color: AppColor.error),
              SizedBox(width: 2.w),
              Text('Delete', style: TxtStyle.itemDelete),
            ],
          )),
    );
  }
}
