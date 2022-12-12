import 'package:flutter/cupertino.dart';
import 'package:onyxsio/onyxsio.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    required this.switchValue,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final Function(bool?) onChanged;
  final bool switchValue;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 20.h,
      padding:
          EdgeInsets.symmetric(vertical: 3.w).copyWith(left: 5.w, right: 2.w),
      margin: EdgeInsets.symmetric(vertical: 2.w),
      decoration: BoxDeco.itemSizeCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TxtStyle.header),
                SizedBox(height: 2.w),
                Text(subtitle, style: TxtStyle.settingSubtitle),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              // This bool value toggles the switch.
              value: switchValue,
              activeColor: CupertinoColors.activeGreen,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
