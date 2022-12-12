import 'dart:async';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final DateTime selectTime;
  const AttendanceScreen({Key? key, required this.selectTime})
      : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  static var countdownDuration1 = const Duration(minutes: 10);

  Duration duration1 = const Duration();
  DateTime now = DateTime.now();
  Timer? timer1;
  bool countDown = true;
  bool countDown1 = true;

  @override
  void initState() {
    // var days = int.parse("2");
    // var hours1 = int.parse("10");
    // var mints1 = int.parse("00");
    // var secs1 = int.parse("00");
    var days = widget.selectTime.day - now.day;
    var hours1 = widget.selectTime.hour - now.hour;
    var mints1 = widget.selectTime.minute - now.minute;
    var secs1 = widget.selectTime.second - now.second;
    countdownDuration1 =
        Duration(days: days, hours: hours1, minutes: mints1, seconds: secs1);
    startTimer1();
    reset1();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    final isRunning = timer1 == null ? false : timer1!.isActive;
    if (isRunning) {
      timer1!.cancel();
    }
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }

  @override
  void dispose() {
    final isRunning = timer1 == null ? false : timer1!.isActive;
    if (isRunning) {
      timer1!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: buildTime1()),
    );
  }

  void reset1() {
    if (countDown) {
      setState(() => duration1 = countdownDuration1);
    } else {
      setState(() => duration1 = const Duration());
    }
  }

  void startTimer1() {
    timer1 = Timer.periodic(const Duration(seconds: 1), (_) => addTime1());
  }

  void addTime1() {
    // final addSeconds = 1;
    setState(() {
      final seconds = duration1.inSeconds - 1;
      if (seconds < 0) {
        timer1?.cancel();
      } else {
        duration1 = Duration(seconds: seconds);
      }
    });
  }

  // Widget buildTime() {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //     buildTimeCard(time: hours, header: 'HOURS'),
  //     SizedBox(
  //       width: 8,
  //     ),
  //     buildTimeCard(time: minutes, header: 'MINUTES'),
  //     SizedBox(
  //       width: 8,
  //     ),
  //     buildTimeCard(time: seconds, header: 'SECONDS'),
  //   ]);
  // }

  Widget buildTime1() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration1.inDays);
    final hours = twoDigits(duration1.inHours);
    final minutes = twoDigits(duration1.inMinutes.remainder(60));
    final seconds = twoDigits(duration1.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: days, header: 'DAYS'),
      const SizedBox(width: 8),
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(width: 8),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(width: 8),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 40),
            ),
          ),
          const SizedBox(height: 24),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );
}
