import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isumi/changes/strings.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';
import 'widget/product_offer.dart';
import 'widget/timer.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({Key? key}) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  var percentage = TextEditingController();
  Uint8List? _image;
  DateTime? selectedTime;
  bool isTimeActive = false;
  //
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the below
    if (mounted) {
      setState(() => _image = im);
    }
  }

  @override
  void dispose() {
    percentage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<SelectedList>(context);
    // final validation = Provider.of<Validation>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildOffersList(context),
            _buildCreateNewBanner(list, context),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _buildOffersList(context) {
    return StreamBuilder(
        stream: FirestoreRepository.offerStream,
        builder: (builder, AsyncSnapshot<QuerySnapshot> snap) {
          if (snap.hasError) {
            return Text('Something went wrong');
          }

          if (snap.connectionState == ConnectionState.waiting) {
            return _buildTopRowItem();
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(top: 5.w),
            children: snap.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  showOfferDetails(data);
                },
                child: FocusedMenuHolder(
                  menuContent: menuContent(context, document.id),
                  child: CachedNetworkImage(
                    imageUrl: data['banner'],
                    height: 35.w,
                    placeholder: (context, url) => _buildTopRowItem(),
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      decoration: BoxDecoration(
                          color: const Color(0XFF212134),
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  Future<void> showOfferDetails(data) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // for (var product in products) {

          return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
              children: [
                Text('This offer expires form', style: TxtStyle.itemUpdate),
                AttendanceScreen(
                  selectTime: DateTime.parse(data['expirationDate']),
                ),
                Space.y5,
                Text('These offering products', style: TxtStyle.itemUpdate),
                Space.y5,
                ...data['products'].map((e) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2.w),
                    width: 20.w,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: e['thumbnail'],
                          placeholder: (context, url) => _buildTopRowItem(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 15.w,
                            width: 15.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fitHeight,
                                )),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Space.x3,
                        Expanded(child: Text(e['title']))
                      ],
                    ),
                  );
                }).toList(),
              ]);
        });
  }

  Padding menuContent(context, id) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: GestureDetector(
            onTap: () async {
              await FirestoreRepository.deleteOffer(id);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppIcon.trash, color: AppColor.error),
                Text('Delete', style: TxtStyle.itemDelete),
              ],
            )));
  }

  Widget _buildTopRowItem() {
    return Shimmer(
      linearGradient: AppColor.shimmerGradient,
      child: ShimmerLoading(
        isLoading: true,
        child: Container(
          height: 35.w,
          margin: EdgeInsets.symmetric(vertical: 2.w),
          decoration: BoxDecoration(
            color: const Color(0XFF212134),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildCreateNewBanner(SelectedList list, context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageUploadSection(),
          _buildProductSelectSection(list, context),
          _buildTimeSelectSection(context),
          _buildPrecentageInputSection(),
          bottomNavigationBar(
            onTap: () {
              _done(list);
            },
            text: 'Give an offer',
          )
        ],
      ),
    );
  }

  Column _buildPrecentageInputSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What is the offering percentage?', style: TxtStyle.itemUpdate),
          Space.y3,
          TextBox(
            controller: percentage,
            type: TXT.price,
            hintText: ' 0% percentage ',
          ),
          Space.y5,
        ],
      );

  Column _buildTimeSelectSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How long will an offer be?', style: TxtStyle.itemUpdate),
        Space.y5,
        if (selectedTime != null && isTimeActive)
          AttendanceScreen(selectTime: selectedTime!),
        ImageButton(
          onTap: () {
            setState(() => isTimeActive = false);
            _selectTime(context);
          },
          text: 'Select Expire',
          image: AppIcon.plus,
        ),
        Space.y5,
      ],
    );
  }

  Column _buildProductSelectSection(SelectedList list, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space.y5,
        Text(CoreTexts.text_2, style: TxtStyle.itemUpdate),
        Space.y5,
        if (list.selectedItems.isNotEmpty)
          Container(
            decoration: BoxDeco.overview,
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcon.dress,
                  color: AppColor.black2,
                  height: 12.w,
                ),
                RichText(
                    text: TextSpan(
                  style: TextStyle(color: AppColor.text, fontSize: 14.sp),
                  children: [
                    const TextSpan(text: 'You have selected '),
                    TextSpan(
                      text: '${list.selectedItems.length}',
                      style: TextStyle(
                          color: AppColor.orange,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' items'),
                  ],
                )),
              ],
            ),
          ),
        Space.y5,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ImageButton(
            onTap: () async {
              // list.selectedItems.clear();
              await productsOffers(
                context: context,
                delegate: OfferSearch(),
              );
              setState(() {});
            },
            text: 'Select products',
            image: AppIcon.plus,
          ),
        ),
        SizedBox(height: 10.w),
      ],
    );
  }

  Column _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space.y5,
        Text('Upload an image', style: TxtStyle.itemUpdate),
        Space.y5,
        if (_image != null)
          SizedBox(
            height: 25.h,
            width: double.infinity,
            child: Image.memory(_image!, fit: BoxFit.cover),
          ),
        Space.y5,
        Text(CoreTexts.text_1, style: TxtStyle.settingSubtitle),
        Space.y5,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ImageButton(
            onTap: selectImage,
            text: 'Upload an image',
            image: AppIcon.camera,
          ),
        ),
      ],
    );
  }

  void _done(list) async {
    if (percentage.text.isNotEmpty &&
        list.selectedItems.isNotEmpty &&
        _image != null &&
        selectedTime != null) {
      Offers offer = Offers(
        percentage: percentage.text,
        expirationDate: selectedTime.toString(),
      );
      await FirestoreRepository.setupOffers(list.selectedItems, offer, _image)
          .whenComplete(() {
        list.selectedItems.clear();
        Navigator.pop(context);
      });
    }
  }

  Future<void> _selectTime(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: SizedBox(
              height: 35.h,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                minimumYear: DateTime.now().year,
                maximumYear: DateTime.now().year + 1,
                minimumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => selectedTime = newDateTime);
                },
              ),
            ),
          );
        });
    setState(() => isTimeActive = true);
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.5,
      title: TXTHeader.header3('Give an offer'),
      leadingWidth: 20.w,
      leading: const ArrowBackButton(),
      bottom: TabBar(
        indicatorWeight: 3,
        indicatorColor: AppColor.yellow,
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(child: TXTHeader.tabbarHeader('Offering Now')),
          Tab(child: TXTHeader.tabbarHeader('Create banner ad')),
        ],
      ),
    );
  }
}
