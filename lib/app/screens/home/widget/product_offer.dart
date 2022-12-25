import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart' as o;
import 'select_card.dart';

class OfferSearch extends o.OfferDeleg<String> {
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
        for (var doc in weightData) {
          if (doc.title!.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(doc);
          }
        }
        return _buildListview(matchQuery);
      },
    );
  }

// last overwrite to show the  querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
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

        List<o.Product> weightData =
            snapshot.data!.docs.map((e) => o.Product.fromSnap(e)).toList();
        for (var doc in weightData) {
          if (doc.title!.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(doc);
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

  // List items = [];

//
  Column _buildListview(List<o.Product> match) {
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
              mainAxisSpacing: 5.h,
              crossAxisSpacing: 5.w,
              childAspectRatio: 0.75,
            ),
            itemCount: match.length,
            itemBuilder: (context, index) {
              var result = match[index];
              // var list = o.Provider.of<o.SelectedList>(context).selectedItems;
              // if (list.contains(result)) {
              //   log('message');
              // }
              return SelectedCard(product: result);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildFilter(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: o.AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: const [
            Text('Filters'),
          ],
        ),
      ),
    );
  }
}
