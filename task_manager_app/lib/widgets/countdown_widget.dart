import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime? deadline;

  const CountdownTimer({Key? key, required this.deadline}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (widget.deadline != null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        setState(() {
          _timeLeft = widget.deadline!.difference(now);
          if (_timeLeft.isNegative) {
            _timer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deadline == null) return Container();

    String timerText = "${_timeLeft.inDays}d ${_timeLeft.inHours % 24}h ${_timeLeft.inMinutes % 60}m ${_timeLeft.inSeconds % 60}s";
    return Text(
      "Time left: $timerText",
      style: TextStyle(color: _timeLeft.isNegative ? Colors.red : Colors.black),
    );
  }
}
