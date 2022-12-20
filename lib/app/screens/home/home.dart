import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

import 'widget/product_manage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<OverView> overView = demoOverview;
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: mainAppBar(text: 'Welcome to store admin'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 5.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMenuTile(
                  name: 'Manage products',
                  onTap: () {
                    // method to show the search bar
                    mySearchDelegate(
                        context: context,
                        // delegate to customize the search bar
                        delegate: SearchScreen());
                  },
                  image: AppIcon.product,
                ),
                _buildMenuTile(
                  name: 'Offers',
                  onTap: () => Navigator.pushNamed(context, '/OfferPage'),
                  image: AppIcon.offer,
                ),
                _buildMenuTile(
                  name: 'Send an alert',
                  onTap: () => Navigator.pushNamed(context, '/SendArlet'),
                  image: AppIcon.message,
                ),
              ],
            ),
            SizedBox(height: 5.w),
            Text('Overview', style: TxtStyle.pageSubHeader),
            // _buildOverviewGrid()
            DashboardInformation(child: getDataFrom, id: user.id)
          ],
        ),
      ),
    );
  }

  Widget getDataFrom(Seller data) {
    return ValueListenableBuilder<Box>(
        valueListenable: HiveDB.sellerBox.listenable(),
        builder: (context, box, widget) {
          // var darkMode = box.get('sellerBox');
          // print(LocalDB.mostSell.);
          return GridView.extent(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            maxCrossAxisExtent: 40.w,
            primary: false,
            padding: EdgeInsets.all(2.w).copyWith(top: 3.w),
            crossAxisSpacing: 5.w,
            mainAxisSpacing: 5.w,
            childAspectRatio: 0.20.h,
            // semanticChildCount: 5,
            children: [
              if (HiveDB.outOfStock(box)!)
                _buildTile('Out Of Stock', data.outOfStock!.length.toString()),
              if (HiveDB.todayOrders(box)!)
                _buildTile(
                    'Today\'s orders', data.todayOrders!.length.toString()),
              if (HiveDB.sold(box)!)
                _buildTile('Sold', data.sold!.length.toString()),
              if (HiveDB.unsold(box)!)
                _buildTile('Unsold', data.unsold!.length.toString()),
              if (HiveDB.todayIncome(box)!)
                _buildTile("Today's income", data.todayIncome!),
              if (HiveDB.totalUsers(box)!)
                _buildTile('Total Users', data.totalUsers!),
              if (HiveDB.mostSell(box)!)
                _buildTile('Most Selling', data.mostSell!.length.toString()),
              if (HiveDB.almostFinished(box)!)
                _buildTile('Near to out stock',
                    data.almostFinished!.length.toString()),
            ],
          );
        });
    // return Wrap(
    //   spacing: 5.w,
    //   runSpacing: 5.w,
    //   children: [
    //     _buildTile('Out Of Stock', '20'),
    //     _buildTile('Today\'s orders', '20'),
    //     _buildTile('Sold', '20'),
    //     _buildTile('Unsold', '20'),
    //     _buildTile("Today's income", '20'),
    //     _buildTile('Total Users', '20'),
    //     _buildTile('Most Selling', '20'),
    //     _buildTile('Near to out stock', '20'),
    //   ],
    // );
  }

  Container _buildTile(String title, String subTitle) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDeco.overview,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TxtStyle.overviewTileHeader,
          ),
          Text(subTitle, style: TxtStyle.overviewTileBody),
        ],
      ),
    );
  }
  // GridView _buildOverviewGrid() {
  //   return GridView.builder(
  //       shrinkWrap: true,
  //       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.w),
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 2.h,
  //         crossAxisSpacing: 4.w,
  //         childAspectRatio: 0.25.h,
  //       ),
  //       itemCount: demoOverview.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           padding: EdgeInsets.all(3.w),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               color: whiteColor,
  //               boxShadow: [blackColorShadow]),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Text(demoOverview[index].outStock.title,
  //                   style: TextStyle(
  //                     fontSize: 13.sp,
  //                     color: const Color(0XFF32324D),
  //                     fontWeight: FontWeight.bold,
  //                   )),
  //               Text(demoOverview[index].outStock.value.toString(),
  //                   style: TextStyle(
  //                     fontSize: 15.sp,
  //                     color: const Color(0XFFFF7B2C),
  //                     fontWeight: FontWeight.bold,
  //                   )),
  //             ],
  //           ),
  //         );
  //       });
  // }

  GestureDetector _buildMenuTile({
    required String name,
    required Function() onTap,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDeco.menuButton,
            child: SvgPicture.asset(image),
          ),
          SizedBox(height: 5.w),
          Text(name, style: TxtStyle.topMenuButton),
        ],
      ),
    );
  }
}
