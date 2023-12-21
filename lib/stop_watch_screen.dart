import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;

  int _time = 0;
  bool _isRunning = false;
  final List<String> _laptimes = [];

  void _clickButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    _isRunning = false;
    _timer?.cancel();
    _laptimes.clear();
    _time = 0;
  }

  void _recordLapTime(String time) {
    _laptimes.insert(0, '${_laptimes.length + 1}등 $time');
  }

  @override
  void dispose() {
    // timer가 null이 아니면 cancel
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = _time ~/ 60;
    String hundreds = '${_time % 60}'.padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$seconds',
                style: const TextStyle(fontSize: 50),
              ),
              Text(
                hundreds,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              width: 100,
              height: 200,

              // ListView: 스크롤 발생시킬때 사용
              child: ListView(
                reverse: true,
                children:
                    _laptimes.map((time) => Center(child: Text(time))).toList(),
              ),
            ),
          ),

          // 공백 넣어줄때 사용됨
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _reset();
                  });
                },
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                  });
                },
                child: _isRunning
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                onPressed: () {
                  _recordLapTime('$seconds.$hundreds');
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
