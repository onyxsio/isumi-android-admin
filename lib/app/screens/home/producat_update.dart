import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

import 'producat_add_veriant.dart';
import 'widget/package_details.dart';

class ProductUpdatePage extends StatefulWidget {
  final Product product;
  const ProductUpdatePage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductUpdatePage> createState() => _ProductUpdatePageState();
}

class _ProductUpdatePageState extends State<ProductUpdatePage> {
  // Create Text Editing Controller
  var pName = TextEditingController();
  var pPrice = TextEditingController();
  // var pQuantity = TextEditingController();
  var pDescription = TextEditingController();
  // var pDiscount = TextEditingController();
  var pDelivery = TextEditingController();
  var pDays = TextEditingController();
  //
  final ImagePicker imagePicker = ImagePicker();
  Package? package = Package();
  // Create List for XFile image
  List<XFile>? imageFileList = [];
  List imagePathList = [];
  List<Variant> productDataList = [];
  // List<ProductVariant> veriantList = [];
  String pickerColor = '0xffFF7B2C';
  String currentColor = '0xffFF7B2C';

  // var seen = [];
  // String pCurrency = '';
  @override
  void initState() {
    defineValues();
    // setVeriant();
    super.initState();
  }

//
  void defineValues() {
    setState(() {
      pName.text = widget.product.title!;
      pDescription.text = widget.product.description!;
      imagePathList.addAll(widget.product.images!);
      package = widget.product.package;
      if (widget.product.shipping!.deliveryPrice != null) {
        pDelivery.text = widget.product.shipping!.deliveryPrice!;
      }
      if (widget.product.shipping!.returnDays != null) {
        pDays.text = widget.product.shipping!.returnDays!;
      }

      // if (widget.product.price!.discount != null) {
      //   pDiscount.text = widget.product.price!.discount!;
      // }
      // if (widget.product.offers!.percentage != null) {
      //   pDiscount.text = widget.product.offers!.percentage!;
      // }
      productDataList.addAll(widget.product.variant!);
    });
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color.value.toString());
  }

//
  void getPackageDetails(Package value) {
    setState(() => package = value);
  }

  //
  void selectImages() async {
    List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(selectedImages);
      });
    }
  }

//
  void getSubVariant() async {
    List<Variant>? products = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductVeriantAddPage(),
      ),
    );
    if (products != null) {
      setState(() => productDataList.addAll(products));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final formvalidation = context.watch<Validation>().isvalid;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TXTHeader.header2("Product name"),
          TextBox(type: TXT.name, controller: pName),
          TXTHeader.header2("Product description"),
          TextBox(type: TXT.description, controller: pDescription),
          TXTHeader.header2("Product images"),
          SizedBox(height: 5.w),
          if (imageFileList!.isNotEmpty) _buildLocalImageGrid(),
          if (imagePathList.isNotEmpty) _buildNetworkImageGrid(),
          const Divider(),
          SizedBox(height: 5.w),
          ImageButton(
              onTap: selectImages,
              image: AppIcon.camera,
              text: 'Select Images'),
          SizedBox(height: 5.w),
          TXTHeader.header2("Create Different variants "),
          SizedBox(height: 5.w),
          if (productDataList.isNotEmpty) _buildLocalVeriantGrid(),
          const Divider(),
          ImageButton(
              onTap: getSubVariant,
              image: AppIcon.dress,
              text: 'Product Variants'),
          SizedBox(height: 5.w),
          PackageDetails(packageFun: getPackageDetails, package: package),
          SizedBox(height: 5.w),
          // TXTHeader.header2("Discount percentage"),
          // TextBox(
          //     type: TXT.discountPrice,
          //     hintText: 'Please enter the discount percentage',
          //     controller: pDiscount),
          TXTHeader.header2("Delivery charge"),
          TextBox(
              type: TXT.deliveryPrice,
              hintText: 'Is there a delivery charge?',
              controller: pDelivery),
          TXTHeader.header2("Return Days"),
          TextBox(
              type: TXT.returnDays,
              hintText: 'Number of days a return is valid',
              controller: pDays),
          SizedBox(height: 5.w),
          MainButton(
              onTap: () {
                if (formvalidation) {
                  // if (isAllNotempty()) {
                  productUpdate();
                  // }
                } else {
                  // TODO

                }
              },
              text: 'Upload')
        ],
      ),
    );
  }

  //
  void productUpdate() async {
    if (productDataList.isNotEmpty &&
        (imageFileList != null || imagePathList.isNotEmpty)) {
      Product product = Product(
        sId: widget.product.sId,
        title: pName.text,
        description: pDescription.text,
        variant: productDataList,
        images: imagePathList,
        rivews: widget.product.rivews,
        shipping: Shipping(
          deliveryPrice: pDelivery.text,
          returnDays: pDays.text,
        ),
        package: package,
      );

      await FirestoreRepository.updateProduct(
        context,
        product,
        imageFileList,
        productDataList,
        // pDiscount.text,
      ).then((value) {
        // DialogBoxes.showAutoCloseDialog(context, message: value);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/MainPage',
          (route) => false,
        );
      });

      // if (resulte == 'success') {
      // showAutoCloseDialog(context, 'success', 'done');
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   '/NChecking',
      //   (route) => false,
      // );
      // }
    } else {
      // showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  //
  GridView _buildLocalImageGrid() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageFileList!.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _buildLocalImageGridTile(index);
        });
  }

  //
  FocusedMenuHolder _buildLocalImageGridTile(int index) {
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

//
  GridView _buildNetworkImageGrid() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imagePathList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _buildNetworkImageGridTile(index);
        });
  }

  //
  FocusedMenuHolder _buildNetworkImageGridTile(int index) {
    return FocusedMenuHolder(
      menuContent: menuContent(index: imagePathList[index]),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: CachedNetworkImage(
          imageUrl: imagePathList[index],
          placeholder: (context, url) => const SizedBox(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

//
  GridView _buildLocalVeriantGrid() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: productDataList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8, crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _buildLocalVeriantGridTile(index);
        });
  }

//
  FocusedMenuHolder _buildLocalVeriantGridTile(int index) {
    return FocusedMenuHolder(
      menuContent: menuContent(index: productDataList[index], isImage: false),
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
                color: Color(int.parse(productDataList[index].color!)),
              ),
              Text(
                'variant : ${productDataList[index].subvariant!.length}',
                // style: TextStyles.b1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Padding menuContent({required index, isImage = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: GestureDetector(
          onTap: () {
            if (isImage) {
              setState(() => imagePathList.remove(index));
            } else {
              setState(() => productDataList.remove(index));
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
