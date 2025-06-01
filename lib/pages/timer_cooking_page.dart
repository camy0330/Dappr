// lib/pages/timer_cooking_page.dart
import 'dart:async'; // Place 'dart:' imports before other imports.
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class TimerCookingPage extends StatefulWidget { // Corrected class name
  const TimerCookingPage({super.key});

  @override
  State<TimerCookingPage> createState() => _TimerCookingPageState();
}

class _TimerCookingPageState extends State<TimerCookingPage> {
  static const int _initialDurationSeconds = 5 * 60; // 5 minutes default
  int _currentDuration = _initialDurationSeconds;
  Timer? _timer;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create an AudioPlayer instance

  @override
  void initState() {
    super.initState();
    // Pre-load audio for faster playback if needed, though 'play' often loads it.
    // _audioPlayer.setSourceAsset('assets/sounds/timer_alarm.mp3');
  }

  void _startTimer() {
    if (_isRunning) return; // Prevent starting if already running
    if (_currentDuration <= 0 && _initialDurationSeconds > 0) {
      _currentDuration = _initialDurationSeconds; // Reset if starting from 0 or finished
    }

    setState(() {
      _isRunning = true;
    });

    _audioPlayer.stop(); // Stop any previous alarm sound if it was playing

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentDuration <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
        _playAlarm(); // Play alarm when timer finishes
      } else {
        setState(() {
          _currentDuration--;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    _audioPlayer.stop(); // Stop alarm if paused
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentDuration = _initialDurationSeconds;
      _isRunning = false;
    });
    _audioPlayer.stop(); // Stop alarm if reset
  }

  Future<void> _playAlarm() async {
    // You can set loopMode to loop until stopped by the user
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await _audioPlayer.play(AssetSource('sounds/timer_alarm.mp3'));
  }

  // Helper to format the time for display
  String _formatDuration(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);
    // Removed unnecessary parentheses as per lint suggestion
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              _formatDuration(_currentDuration),
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Start/Pause Button
              _isRunning
                  ? ElevatedButton.icon(
                      onPressed: _pauseTimer,
                      icon: const Icon(Icons.pause, size: 30),
                      label: const Text('Pause', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _startTimer,
                      icon: const Icon(Icons.play_arrow, size: 30),
                      label: const Text('Start', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
              // Reset Button
              ElevatedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh, size: 30),
                label: const Text('Reset', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}