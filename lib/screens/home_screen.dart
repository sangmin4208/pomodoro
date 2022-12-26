import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int twentyFiveMinutes = 25 * 60;
  static const int intialSeconds = twentyFiveMinutes;
  int totalSeconds = intialSeconds;
  Timer? timer;
  int pomodoroCount = 0;
  bool get isRunning => timer?.isActive ?? false;
  bool get isPaused => !isRunning && totalSeconds != intialSeconds;
  void onTick(Timer time) {
    setState(() {
      if (totalSeconds > 0) {
        totalSeconds--;
      } else {
        timer?.cancel();
        setState(() {
          pomodoroCount++;
          totalSeconds = intialSeconds;
        });
      }
    });
  }

  String get formattedTime {
    // final int minutes = totalSeconds ~/ 60;
    // final int seconds = totalSeconds % 60;
    // return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    /// duration
    // final Duration duration = Duration(seconds: totalSeconds);
    // return duration.toString().substring(2, 7);

    /// duration 2
    final Duration duration = Duration(seconds: totalSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  void onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void onPausePressed() {
    timer?.cancel();
    setState(() {});
  }

  void onStopPressed() {
    timer?.cancel();
    setState(() {
      totalSeconds = intialSeconds;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                formattedTime,
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Center(
                child: _renderTimerButton(),
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pomodoros',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$pomodoroCount',
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderTimerButton() {
    if (isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimerButton.pause(onPressed: onPausePressed),
          TimerButton.stop(onPressed: onStopPressed),
        ],
      );
    }
    if (isPaused) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerButton.play(onPressed: onStartPressed),
          TimerButton.reset(
            onPressed: onStopPressed,
            size: 60,
          ),
        ],
      );
    }
    return TimerButton.play(onPressed: onStartPressed);
  }
}

class TimerButton extends StatelessWidget {
  const TimerButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 120,
  }) : super(key: key);
  const TimerButton.play({
    Key? key,
    required this.onPressed,
    this.size = 120,
  })  : icon = Icons.play_circle_outlined,
        super(key: key);

  const TimerButton.pause({
    Key? key,
    required this.onPressed,
    this.size = 120,
  })  : icon = Icons.pause_circle_outlined,
        super(key: key);

  const TimerButton.stop({
    Key? key,
    required this.onPressed,
    this.size = 120,
  })  : icon = Icons.stop_circle_outlined,
        super(key: key);
  const TimerButton.reset({
    Key? key,
    required this.onPressed,
    this.size = 120,
  })  : icon = Icons.refresh_outlined,
        super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final int size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size.toDouble(),
      color: Theme.of(context).cardColor,
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
    );
  }
}
