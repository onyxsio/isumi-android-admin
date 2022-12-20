import 'package:flutter/material.dart';
import 'package:isumi/core/utils/utils.dart';
import 'package:onyxsio/onyxsio.dart';

class ProductVeriantAddPage extends StatefulWidget {
  const ProductVeriantAddPage({Key? key}) : super(key: key);

  @override
  State<ProductVeriantAddPage> createState() => _ProductVeriantAddPageState();
}

class _ProductVeriantAddPageState extends State<ProductVeriantAddPage> {
  var quantityTECs = <TextEditingController>[];
  var priceTECs = <TextEditingController>[];
  var sizeTECs = <TextEditingController>[];
  var cards = <Container>[];
  String pickerColor = '0xffFF7B2C';
  String currentColor = '0xffFF7B2C';
  String productSize = '';

  //
  void getCurrancy(String value) {}

  @override
  void initState() {
    super.initState();
    cards.add(createCard());
  }

  _onDone() {
    List<Variant> entries = [];
    List<Subvariant> sub = [];
    for (int i = 0; i < cards.length; i++) {
      if (quantityTECs[i].text.isNotEmpty) {
        var quantity = quantityTECs[i].text;
        var price = double.parse(priceTECs[i].text);
        var size = sizeTECs[i].text;
        sub.add(
            Subvariant(price: price.toString(), size: size, stock: quantity));
      }
    }
    entries.add(Variant(color: pickerColor, subvariant: sub));
    Navigator.pop(context, entries);
    sizeTECs.clear();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    // final formvalidation = Provider.of<ValidationProvider>(context);

    // LocalDB.getCurrency;
    return Scaffold(
      appBar: ternaryAppBar(text: "Let’s add a new product"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TXTHeader.header2("Select a color"),
            SizedBox(height: 5.w),
            ColorPicker(
              pickerColor: Color(int.parse(pickerColor)),
              onColorChanged: changeColor,
            ),
            SizedBox(height: 5.w),
            SizedBox(
              // height: 50.w,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return FocusedMenuHolder(
                      menuContent: menuContent(index: cards[index]),
                      child: cards[index]);
                },
              ),
            ),
            MainButton(
                // onTap: () => setState(() => cards.add(createCard())),
                onTap: () {
                  if (quantityTECs[cards.length - 1].text.isNotEmpty) {
                    setState(() => cards.add(createCard()));
                  }
                },
                text: 'Add a new sub-product variant'),
            SizedBox(height: 5.w),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.white,
        onPressed: _onDone,
        child: SvgPicture.asset(AppIcon.add),
      ),
    );
  }

  //
  Container createCard() {
    var quantityController = TextEditingController();
    var priceController = TextEditingController();
    var sizeController = TextEditingController();

    quantityTECs.add(quantityController);
    priceTECs.add(priceController);
    sizeTECs.add(sizeController);

    return Container(
      padding: EdgeInsets.all(5.w),
      margin: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ValueListenableBuilder<Box>(
          valueListenable: HiveDB.box.listenable(),
          builder: (context, box, widget) {
            var currency = box.get('currency');
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.w),
                TXTHeader.header2("Product price"),
                TextBox(
                  controller: priceController,
                  prefixText: currency,
                  type: TXT.price,
                ),
                TXTHeader.header2("Product quantity"),
                TextBox(
                  controller: quantityController,
                  type: TXT.quantity,
                ),
                ProductSizeDropList(
                  (optionItem) {
                    setState(() => sizeController.text = optionItem);
                  },
                  sizeList: sizeTECs,
                ),
              ],
            );
          }),
    );
  }

//
  Padding menuContent({required index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: GestureDetector(
          onTap: () {
            setState(() => cards.remove(index));
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
