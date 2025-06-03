import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Simpan notes untuk setiap hari
  Map<DateTime, Map<String, String>> _mealNotes = {};

  final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner'];

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _showMealNoteDialog(selectedDay);
  }

  void _showMealNoteDialog(DateTime day) {
    Map<String, TextEditingController> controllers = {
      for (var meal in _meals)
        meal: TextEditingController(
            text: _mealNotes[day] != null ? _mealNotes[day]![meal] ?? '' : '')
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Meal Notes (${_formatDate(day)})'),
        content: SingleChildScrollView(
          child: Column(
            children: _meals.map((meal) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controllers[meal],
                  decoration: InputDecoration(
                    labelText: meal,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _mealNotes[day] = {
                  for (var meal in _meals) meal: controllers[meal]!.text
                };
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // New: Show bottom sheet with meal summary when tap dot
  void _showMealSummary(DateTime day) {
    final notes = _mealNotes[day];
    if (notes == null || notes.values.every((note) => note.trim().isEmpty)) {
      // No meal notes for this day
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No meal notes for this day.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meal Summary for ${_formatDate(day)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ..._meals.map((meal) {
              final text = notes[meal]?.trim();
              if (text == null || text.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '$meal:\n$text',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dot builder with onTap
  Widget _buildEventsMarker(DateTime day, List events) {
    // Show dot only if mealNotes for day exists and has any non-empty meal note
    if (_mealNotes[day] == null ||
        _mealNotes[day]!.values.every((note) => note.trim().isEmpty)) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _showMealSummary(day);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal, // warna dot latest
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        backgroundColor: Colors.deepOrange,
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        // Add dot below date if meal notes exist for that day
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            return _buildEventsMarker(day, events);
          },
        ),
      ),
    );
  }
}
