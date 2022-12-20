import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';

// TODO
class TestDataOrder extends StatelessWidget {
  const TestDataOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Set data to Order Db'),
          onPressed: () {
            // FirestoreRepository.setupOrder();
          },
        ),
      ),
    );
  }

  void setdata() async {}
}
