import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class SelectedCard extends StatefulWidget {
  final Product product;

  const SelectedCard({Key? key, required this.product}) : super(key: key);

  @override
  State<SelectedCard> createState() => _SelectedCardState();
}

class _SelectedCardState extends State<SelectedCard> {
  bool isClick = false;
  int index = 0;
  late List<Product> _list;
  @override
  void initState() {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _list =
          Provider.of<SelectedList>(context, listen: false).selectedItems);

      // for (var element in _list)
      for (int i = 0; i < _list.length; i++) {
        if (_list[i].sId!.contains(widget.product.sId!)) {
          setState(() {
            isClick = true;
            index = i;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (!isClick) {
            _list.add(widget.product);
          } else {
            // _list.remove(widget.product);
            _list.removeAt(index);
          }
          isClick = !isClick;
        });
      },
      child: Stack(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 5.w),
            decoration: BoxDeco.itemCard,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                    imageUrl: widget.product.thumbnail!,
                    height: 35.w,
                    // width: 32.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              )),
                        )),
                _buildPrice(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    children: [
                      if (widget.product.stock != null)
                        Row(
                          children: [
                            Text(widget.product.stock!, style: TxtStyle.b2),
                            Text(' sold', style: TxtStyle.b3B),
                          ],
                        ),
                      if (widget.product.rivews != null &&
                          double.parse(widget.product.rivews!.ratingValue!) > 0)
                        Row(
                          children: [
                            Space.x3,
                            Icon(
                              Icons.star,
                              color: AppColor.yellow,
                              size: 4.w,
                            ),
                            Space.x1,
                            Text(
                              widget.product.rivews!.ratingValue!,
                              style: TxtStyle.topMenuButton,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w)
                      .copyWith(bottom: 2.w),
                  child: Text(
                    widget.product.title!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TxtStyle.itemCardHeading,
                  ),
                ),
              ],
            ),
          ),
          if (widget.product.offers != null &&
              widget.product.offers!.percentage!.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: AppColor.error,
                    // borderRadius:
                    //     BorderRadius.only(topLeft: Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      '-${widget.product.offers!.percentage!} %',
                      style: TxtStyle.topMenuButton
                          .copyWith(color: AppColor.white),
                    ),
                  )),
            ),
          Container(decoration: isClick ? BoxDeco.selectedCard : null)
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: RichText(
          text: TextSpan(
        children: [
          TextSpan(
              text: Utils.currencySymble(name: widget.product.price!.currency),
              style: TxtStyle.itemCardcurrency),
          const TextSpan(text: ' '),
          TextSpan(
              text: Utils.value(
                  name: widget.product.price!.currency,
                  amount: double.parse(widget.product.price!.value!)),
              style: TxtStyle.itemCardPrice),
        ],
      )),
    );
  }
}
