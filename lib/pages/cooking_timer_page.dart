// lib/pages/cooking_timer_page.dart
import 'dart:async'; // This MUST be present for Timer

import 'package:audioplayers/audioplayers.dart'; // This MUST be present and working
import 'package:flutter/material.dart';

class CookingTimerPage extends StatefulWidget {
  const CookingTimerPage({super.key});

  @override
  State<CookingTimerPage> createState() => _CookingTimerPageState();
}

class _CookingTimerPageState extends State<CookingTimerPage> {
  late AudioPlayer _audioPlayer;
  Timer? _timer;
  int _startSeconds = 0;
  int _currentSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    if (_startSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a timer duration!')),
      );
      return;
    }

    _isRunning = true;
    _currentSeconds = _startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds == 0) {
        timer.cancel();
        _isRunning = false;
        _playAlarm();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Timer Finished!')),
        );
      } else {
        setState(() {
          _currentSeconds--;
        });
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _audioPlayer.stop();
    setState(() {
      _isRunning = false;
      _currentSeconds = 0;
      _startSeconds = 0;
    });
  }

  void _playAlarm() async {
    await _audioPlayer.play(AssetSource('sounds/timer_alarm.mp3'));
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cooking Timer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_currentSeconds),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Set Minutes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _startSeconds = (int.tryParse(value) ?? 0) * 60;
                    if (!_isRunning) _currentSeconds = _startSeconds;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
