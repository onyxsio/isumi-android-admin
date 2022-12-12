import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';

class SendArlet extends StatefulWidget {
  const SendArlet({Key? key}) : super(key: key);

  @override
  State<SendArlet> createState() => _SendArletState();
}

class _SendArletState extends State<SendArlet> {
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ternaryAppBar(text: 'Send an alert'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.w),
            TXTHeader.header2("Message title"),
            TextBox(
              controller: title,
              type: TXT.text,
              hintText: 'title',
            ),
            TXTHeader.header2("Message"),
            TextBox(
              controller: message,
              type: TXT.text,
              hintText: 'message',
            ),
            // SizedBox(height: 5.w),
            Text('you can send messages via notification to all Customers',
                style: TxtStyle.settingSubtitle),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        onTap: () async {
          await FireMessage.sendMessage(title.text, message.text).then((value) {
            clear();
            Navigator.pop(context);
          });
        },
        text: 'Send messages',
      ),
    );
  }

  void clear() {
    title.clear();
    message.clear();
  }
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
