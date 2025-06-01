// lib/pages/timer_cooking_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // For real notifications (mobile)

// // For local notifications (mobile specific, conceptual for now)
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

class TimerCookingPage extends StatefulWidget {
  const TimerCookingPage({super.key});

  @override
  State<TimerCookingPage> createState() => _TimerCookingPageState();
}

class _TimerCookingPageState extends State<TimerCookingPage> {
  static const String _prefKeyTimerEndTime = 'timer_end_time';
  static const String _prefKeyTimerIsRunning = 'timer_is_running';
  static const String _prefKeyTimerDuration = 'timer_duration';

  int _currentDuration = 0; // Current time left in seconds
  Timer? _timer;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _minutesController = TextEditingController();

  // Variables to store timer state for persistence
  DateTime? _timerEndTime;
  int _initialSetDuration = 0; // The duration the user set

  @override
  void initState() {
    super.initState();
    _loadTimerState();
    // Initialize local notifications (mobile specific, conceptual)
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon'); // Replace with your app icon name
    // const DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings();
    // const InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final timerEndTimeMillis = prefs.getInt(_prefKeyTimerEndTime);
    final isRunning = prefs.getBool(_prefKeyTimerIsRunning) ?? false;
    final savedDuration = prefs.getInt(_prefKeyTimerDuration) ?? 0;

    if (timerEndTimeMillis != null && isRunning) {
      final savedEndTime = DateTime.fromMillisecondsSinceEpoch(timerEndTimeMillis);
      final remainingDuration = savedEndTime.difference(DateTime.now()).inSeconds;

      if (remainingDuration > 0) {
        setState(() {
          _currentDuration = remainingDuration;
          _initialSetDuration = savedDuration;
          _minutesController.text = (remainingDuration ~/ 60).toString();
          _isRunning = true;
        });
        _startTimerTick(); // Resume ticking from saved state
      } else {
        // Timer already finished in background
        _resetTimer(); // Reset for a clean slate
        _showFinishedNotification(); // Show notification that it finished
      }
    } else {
      // No saved timer or it was paused/reset
      _resetTimer(); // Set to default state (e.g., 5 minutes)
    }
  }

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isRunning && _timerEndTime != null) {
      await prefs.setInt(_prefKeyTimerEndTime, _timerEndTime!.millisecondsSinceEpoch);
      await prefs.setBool(_prefKeyTimerIsRunning, true);
      await prefs.setInt(_prefKeyTimerDuration, _initialSetDuration);
    } else {
      // Clear saved state if timer is not running or was reset/paused
      await prefs.remove(_prefKeyTimerEndTime);
      await prefs.remove(_prefKeyTimerIsRunning);
      await prefs.remove(_prefKeyTimerDuration);
    }
  }

  void _startTimer() {
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    if (minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a valid duration in minutes.', style: TextStyle(fontFamily: 'Montserrat'))),
      );
      return;
    }

    _initialSetDuration = minutes * 60;
    _currentDuration = _initialSetDuration;
    _timerEndTime = DateTime.now().add(Duration(seconds: _currentDuration));

    _timer?.cancel(); // Cancel any existing timer
    _audioPlayer.stop();

    setState(() {
      _isRunning = true;
    });

    _saveTimerState(); // Save state immediately

    _startTimerTick(); // Start the ticking
  }

  void _startTimerTick() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_timerEndTime != null && now.isBefore(_timerEndTime!)) {
        setState(() {
          _currentDuration = _timerEndTime!.difference(now).inSeconds;
        });
      } else {
        // Timer has ended
        timer.cancel();
        setState(() {
          _currentDuration = 0; // Ensure it's exactly 0
          _isRunning = false;
        });
        _resetTimerStateInPrefs(); // Clear saved state
        _playAlarm();
        _showFinishedNotification(); // Show notification
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    _audioPlayer.stop();
    _resetTimerStateInPrefs(); // Clear saved state on pause
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentDuration = 5 * 60; // Default to 5 minutes on reset
      _minutesController.text = '5'; // Set text field to 5 minutes
      _isRunning = false;
    });
    _audioPlayer.stop();
    _resetTimerStateInPrefs(); // Clear saved state on reset
  }

  Future<void> _resetTimerStateInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyTimerEndTime);
    await prefs.remove(_prefKeyTimerIsRunning);
    await prefs.remove(_prefKeyTimerDuration);
  }

  Future<void> _playAlarm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/timer_alarm.mp3')); // Ensure this asset exists
  }

  void _showFinishedNotification() {
    // This is a basic in-app notification using SnackBar.
    // For true cross-app notifications (Android/iOS), you need flutter_local_notifications
    // and platform-specific setup.

    if (mounted) { // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Timer Finished!',
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
        ),
      );
    }

    // // Example for flutter_local_notifications (mobile specific, uncomment for full setup)
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(
    //   'timer_channel', // id
    //   'Timer Notifications', // name
    //   channelDescription: 'Notifications for cooking timers',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   showWhen: false,
    // );
    // const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    //     DarwinNotificationDetails();
    // const NotificationDetails platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics,
    //     iOS: iOSPlatformChannelSpecifics);
    // flutterLocalNotificationsPlugin.show(
    //   0, // notification id
    //   'Dappr Timer',
    //   'Your cooking timer has finished!',
    //   platformChannelSpecifics,
    //   payload: 'timer_finished',
    // );
  }


  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _minutesController.dispose();
    _saveTimerState(); // Save state when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Colors.black87,
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
                  onPressed: _isRunning ? null : _startTimer, // Disable if already running
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.grey : Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start', style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : null, // Enable only if running
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.amber : Colors.grey,
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
              enabled: !_isRunning, // Disable text field when timer is running
              decoration: InputDecoration(
                labelText: 'Set Minutes',
                hintText: 'e.g., 5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: const TextStyle(fontFamily: 'Montserrat'),
              onSubmitted: (value) => _startTimer(),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}