import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:remote_data/remote_data.dart';

class VariantInfo extends StatefulWidget {
  const VariantInfo({Key? key, required this.pid}) : super(key: key);

  final String pid;

  @override
  State<VariantInfo> createState() => _VariantInfoState();
}

class _VariantInfoState extends State<VariantInfo> {
  String vId = '';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireRepo.productsDB
          .doc(widget.pid)
          .collection('variants')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: HRDots());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: HRDots());
        }

        return Column(
          children: [
            GridView.extent(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 2.w,
              crossAxisSpacing: 2.w,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          vId = document.id;
                        });
                      },
                      child: Container(
                        height: 12.w,
                        width: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(data['color'])),
                          // border: selectedColor == i
                          //     ? Border.all(color: AppColor.yellow, width: 4)
                          //     : null,
                        ),
                      ),
                    ),
                  ],
                );

                // return ListTile(
                //   title: Text(data['full_name']),
                //   subtitle: Text(data['company']),
                // );
              }).toList(),
            ),
            SizedBox(
              height: 150,
              child: SubVariantInfo(
                pid: widget.pid,
                vId: vId,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SubVariantInfo extends StatelessWidget {
  const SubVariantInfo({
    Key? key,
    required this.pid,
    // required this.sid,
    required this.vId,
  }) : super(key: key);

  final String vId, pid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireRepo.productsDB
          .doc(pid)
          .collection('variants')
          .doc(vId)
          .collection('subvariant')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: HRDots());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: HRDots());
        }

        return GridView.extent(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          maxCrossAxisExtent: 40,
          mainAxisSpacing: 2.w,
          crossAxisSpacing: 2.w,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Container(
              height: 12.w,
              width: 12.w,
              decoration: BoxDeco.subveriantbox(false),
              child: Center(
                  child: Text(
                data['size'],
                style: TxtStyle.size(false),
              )),
            );

            // return ListTile(
            //   title: Text(data['full_name']),
            //   subtitle: Text(data['company']),
            // );
          }).toList(),
        );
      },
    );
  }

  // Widget _buildColorGrid() => GridView.extent(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     maxCrossAxisExtent: 40,
  //     mainAxisSpacing: 2.w,
  //     crossAxisSpacing: 2.w,
  //     children: _buildGridTileList());

  // List<Widget> _buildGridTileList() => List.generate(
  //     veriants.length,
  //     (i) => GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               selectedColor = i;
  //               selectedSize = 0;
  //               price = convertToSize(veriants[i])[0].price!;
  //             });
  //           },
  //           child: Container(
  //             height: 12.w,
  //             width: 12.w,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Color(int.parse(veriants[i].color!)),
  //               border: selectedColor == i
  //                   ? Border.all(color: AppColor.yellow, width: 4)
  //                   : null,
  //             ),
  //           ),
  //         ));
}
