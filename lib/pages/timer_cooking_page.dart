// lib/pages/timer_cooking_page.dart
import 'dart:async'; // Place 'dart:' imports before other imports.
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class TimerCookingPage extends StatefulWidget {
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
  final TextEditingController _minutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minutesController.text = (_initialDurationSeconds ~/ 60).toString(); // Set initial text to 5 minutes
  }

  void _startTimer() {
    // Parse minutes from the text field
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    if (minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a valid duration in minutes.', style: TextStyle(fontFamily: 'Montserrat'))),
      );
      return;
    }

    _currentDuration = minutes * 60; // Set duration based on input

    if (_isRunning) return; // Prevent starting if already running
    
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
      _currentDuration = _initialDurationSeconds; // Reset to initial default
      _minutesController.text = (_initialDurationSeconds ~/ 60).toString(); // Update input field
      _isRunning = false;
    });
    _audioPlayer.stop(); // Stop alarm if reset
  }

  Future<void> _playAlarm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await _audioPlayer.play(AssetSource('sounds/timer_alarm.mp3'));
  }

  // Helper to format the time for display
  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    _audioPlayer.dispose(); // Dispose the audio player
    _minutesController.dispose(); // Dispose the text editing controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Added Scaffold for AppBar and consistent background
      appBar: AppBar(
        title: const Text('Cooking Timer', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
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
                  color: Colors.black87, // Changed to black for better contrast
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.grey : Colors.deepOrange, // Grey if running
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                ),
                ElevatedButton(
                  onPressed: _pauseTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.amber : Colors.grey, // Amber if running
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Pause', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Set Minutes',
                hintText: 'e.g., 5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: const TextStyle(fontFamily: 'Montserrat'),
              onSubmitted: (value) => _startTimer(), // Start timer on submit
            ),
          ),
          const SizedBox(height: 50), // Add some space at the bottom
        ],
      ),
    );
  }
}