import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart' as o;
import 'producat_card.dart';

class SearchScreen extends o.SearchDelegate<String> {
  @override
  Widget buildResults(BuildContext context) {
    List<o.Product> matchQuery = [];
    return StreamBuilder<o.QuerySnapshot>(
      stream: o.FireRepo.productStream,
      builder: (BuildContext context, AsyncSnapshot<o.QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        List<o.Product> weightData = snapshot.data!.docs
            .map((e) => o.Product.fromJson(e as Map<String, dynamic>))
            .toList();
        if (query.isNotEmpty) {
          for (var doc in weightData) {
            if (doc.title!.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(doc);
            }
          }
        }

        return _buildListview(matchQuery);
      },
    );
  }

// last overwrite to show the  querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    return StreamBuilder<o.QuerySnapshot>(
      stream: o.FireRepo.productStream,
      builder: (BuildContext context, AsyncSnapshot<o.QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        List<o.Product> weightData =
            snapshot.data!.docs.map((e) => o.Product.fromSnap(e)).toList();
        if (query.isNotEmpty) {
          for (var doc in weightData) {
            if (doc.title!.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(doc);
            }
          }
        }

        return _buildListview(matchQuery);
      },
    );
  }

  bool value = false;

  bool isListView(bool val) {
    return value = val;
  }

  // String rating = '0';
//
  Column _buildListview(List<dynamic> match) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: o.itemsFound(number: match.length)),
              Container(
                height: 10.w,
                width: 1,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                color: o.AppColor.black.withOpacity(0.2),
              ),
              o.ListOrGridButton(onTap: isListView)
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 4.w,
              childAspectRatio: 0.75,
            ),
            itemCount: match.length,
            itemBuilder: (context, index) {
              var result = match[index];
              return o.FocusedMenuHolder(
                  menuContent: menuContent(context, result),
                  child: GridProductCard(product: result));
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildFilter(BuildContext context) {
    // matchQuery
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: o.AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                // rating = '10.00';
              },
              child: const Text('Filters'),
            )
          ],
        ),
      ),
    );
  }

  Padding menuContent(context, result) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                // FireStoreMethods.deleteProduct(result.id);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  o.SvgPicture.asset(AppIcon.trash, color: o.AppColor.error),
                  Text('Delete', style: o.TxtStyle.itemDelete),
                ],
              )),
          SizedBox(height: 5.w),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ProductUpdate',
                    arguments: result);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  o.SvgPicture.asset(AppIcon.edit, color: o.AppColor.error),
                  Text('Update', style: o.TxtStyle.itemUpdate),
                ],
              )),
        ],
      ),
    );
  }
}
