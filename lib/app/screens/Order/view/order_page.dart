import 'package:flutter/material.dart';
import 'package:isumi/app/screens/Order/view/test_data.dart';
import 'package:onyxsio/onyxsio.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            OrderInformation(id: user.id),
            DeliveredInformation(id: user.id),
            const TestDataOrder(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1,
      title: TXTHeader.pageHeader('My orders'),
      actions: const [MenuButton()],
      bottom: TabBar(
        indicatorWeight: 3,
        indicatorColor: AppColor.yellow,
        // isScrollable: true,
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          TXTHeader.tabbarHeader('Now'),
          TXTHeader.tabbarHeader('Delivered'),
          Tab(child: TXTHeader.tabbarHeader('Canceled')),
        ],
      ),
    );
  }
}
