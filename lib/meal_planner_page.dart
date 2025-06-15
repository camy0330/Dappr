import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<String> _meals = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Additional Meal'
  ];
  Map<DateTime, Map<String, String>> _mealNotes = {}; // Stores meal notes by date and meal type
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay;

    // Listener for tab changes to update selected day if necessary
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // If no day is selected or the selected day is not the focused day,
          // set the selected day to the current focused day.
          if (_selectedDay == null || !isSameDay(_selectedDay!, _focusedDay)) {
            _selectedDay = _focusedDay;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Callback function when a day is selected on the calendar
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // Automatically switch to the 'Daily' tab (index 2) when a day is selected
    _tabController.animateTo(2);
    // Show the meal note dialog for the selected day
    _showMealNoteDialog(selectedDay);
  }

  // Helper to get an icon for each meal type
  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.egg_alt_outlined;
      case 'Lunch':
        return Icons.lunch_dining_outlined;
      case 'Dinner':
        return Icons.dinner_dining_outlined;
      case 'Additional Meal':
        return Icons.add_box_outlined;
      default:
        return Icons.restaurant_menu;
    }
  }

  // Dialog to add or edit meal notes for a specific day
  void _showMealNoteDialog(DateTime day) {
    // Normalize the day to ensure consistency for map keys (removes time component)
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    _mealNotes.putIfAbsent(normalizedDay, () => {}); // Ensure map entry exists for the day

    // Create a TextEditingController for each meal type to pre-fill with existing notes
    Map<String, TextEditingController> controllers = {
      for (var meal in _meals)
        meal: TextEditingController(text: _mealNotes[normalizedDay]![meal] ?? '')
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // More rounded corners for dialog
        title: Text(
          'Add Meal Notes (${_formatDate(normalizedDay, 'EEE, MMM d,yyyy')})',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _meals.map((meal) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controllers[meal],
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: meal,
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    floatingLabelStyle: const TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Softer corners
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Colors.grey.shade200), // Subtle border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100, // Light fill color for text field
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  maxLines: 4, // Allow multiple lines for notes
                  textCapitalization: TextCapitalization.sentences, // Capitalize first letter of each sentence
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dispose controllers to prevent memory leaks
              for (var controller in controllers.values) {
                controller.dispose();
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mealNotes.putIfAbsent(normalizedDay, () => {}); // Ensure map entry exists
                for (var meal in _meals) {
                  // Update or set the note for each meal type
                  _mealNotes[normalizedDay]![meal] = controllers[meal]!.text.trim();
                }
                // If all notes for the day are empty, remove the day's entry from the map
                if (_mealNotes[normalizedDay]!.values.every((note) => note.isEmpty)) {
                  _mealNotes.remove(normalizedDay);
                }
              });
              // Dispose controllers and close dialog
              for (var controller in controllers.values) {
                controller.dispose();
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Matches input field
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 3,
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to confirm deletion of a meal note
  void _deleteMealNote(DateTime day, String mealType) {
    // Normalize the day for consistency
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Meal Note',
            style: TextStyle(color: Colors.deepOrange)),
        content: Text(
            'Are you sure you want to delete the $mealType note for ${_formatDate(normalizedDay, 'EEE, MMM d,yyyy')}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style:
                TextButton.styleFrom(foregroundColor: Colors.blueGrey.shade600),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_mealNotes.containsKey(normalizedDay)) {
                  _mealNotes[normalizedDay]!.remove(mealType); // Remove specific meal note
                  // If all notes for the day are empty after removal, remove the day's entry
                  if (_mealNotes[normalizedDay]!
                      .values
                      .every((note) => note.trim().isEmpty)) {
                    _mealNotes.remove(normalizedDay);
                  }
                }
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget to build a small marker on calendar days that have notes
  Widget _buildEventsMarker(DateTime day, List events) {
    // Normalize the day for consistency
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    // If there are no notes for this day, or all notes are empty, don't show a marker
    if (_mealNotes[normalizedDay] == null ||
        _mealNotes[normalizedDay]!.values.every((note) => note.trim().isEmpty)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 2, // Position the marker at the bottom of the day cell
      child: GestureDetector(
        onTap: () => _showMealSummary(normalizedDay), // Show summary when marker is tapped
        child: Container(
          width: 7, // Size of the marker
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal.shade400, // Color of the marker
            boxShadow: [
              BoxShadow(
                // Fix for deprecated withOpacity: Use withAlpha for direct alpha control
                color: Colors.teal.shade200.withAlpha((255 * 0.5).round()),
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shows a modal bottom sheet with a summary of meal notes for a selected day
  void _showMealSummary(DateTime day) {
    // Normalize the day for consistency
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    final notes = _mealNotes[normalizedDay]; // Get notes for the normalized day
    
    // If no notes or all notes are empty, show a snackbar and return
    if (notes == null || notes.values.every((note) => note.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No meal notes for this day.')),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be dragged higher
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(30)), // More pronounced top curve
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false, // Don't expand to full screen by default
        initialChildSize: 0.4, // Initial height of the sheet
        minChildSize: 0.2, // Minimum height when dragged down
        maxChildSize: 0.8, // Maximum height when dragged up
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(25), // Increased padding within the sheet
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50, // Wider drag handle
                    height: 6, // Thicker drag handle
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Increased spacing
                Text(
                  'Meal Summary for ${_formatDate(normalizedDay, 'EEEE, MMM d,yyyy')}', // Display formatted date
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.deepOrange),
                ),
                const Divider(
                    height: 30,
                    thickness: 1.2,
                    color: Colors.grey), // Thicker divider
                Expanded( // Allows the list of notes to scroll
                  child: ListView(
                    controller: scrollController,
                    children: _meals.map((meal) {
                      final text = notes[meal]?.trim();
                      if (text == null || text.isEmpty) {
                        return const SizedBox.shrink(); // Hide if no note for this meal type
                      }
                      return Card(
                        margin:
                            const EdgeInsets.only(bottom: 15), // More spacing between cards
                        elevation: 2, // Subtle elevation for cards
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15)), // Matching card radius
                        child: Padding(
                          padding:
                              const EdgeInsets.all(15), // Increased padding inside card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$meal:',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 6), // More spacing
                              Text(
                                text,
                                style: const TextStyle(
                                    fontSize: 15.5, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10), // Spacing before close button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10)),
                    child: const Text('Close', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper function to format DateTime objects into strings
  String _formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  // Helper function to get all dates in the current week based on selectedDay
  List<DateTime> _getCurrentWeekDates(DateTime selectedDay) {
    final weekday = selectedDay.weekday; // Monday is 1, Sunday is 7
    // Calculate the start of the week (Monday)
    final startOfWeek = selectedDay.subtract(Duration(days: weekday - 1));
    // Generate a list of 7 days starting from Monday
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  // Widget to build the weekly view of meal notes
  Widget _buildWeeklyView() {
    final weekDates = _getCurrentWeekDates(_selectedDay ?? DateTime.now());
    return ListView.builder(
      padding: const EdgeInsets.all(16), // Increased padding
      itemCount: weekDates.length,
      itemBuilder: (context, index) {
        final day = weekDates[index];
        // Normalize the day for consistency
        final DateTime normalizedDay = DateTime(day.year, day.month, day.day);

        _mealNotes.putIfAbsent(normalizedDay, () => {}); // Ensure map entry exists
        final notes = _mealNotes[normalizedDay]!; // Get notes for the normalized day

        // Check if there are any non-empty notes for the day
        final bool hasAnyNotes =
            notes.values.any((note) => note.trim().isNotEmpty);

        return Card(
          elevation: 5, // Increased elevation for a floating effect
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // More rounded corners
          margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 4), // More vertical margin
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showMealNoteDialog(normalizedDay), // Open dialog to add/edit notes
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(normalizedDay, 'EEEE, MMMM d,yyyy'), // Display formatted date
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Slightly larger
                        color: Colors.deepOrange),
                  ),
                  const Divider(height: 20, thickness: 1.2), // Thicker divider
                  ..._meals.map((meal) {
                    final text = notes[meal]?.trim();
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8.0), // More spacing
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120, // Fixed width for meal type label
                            child: Text(
                              '$meal: ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                          ),
                          Expanded( // Allows meal note text to take remaining space
                            child: Text(
                              text?.isEmpty ?? true ? 'No notes' : text!,
                              style: TextStyle(
                                  fontStyle: text?.isEmpty ?? true
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  color: text?.isEmpty ?? true
                                      ? Colors.grey.shade600
                                      : Colors.black54), // Softer text color
                              maxLines: 2, // Limit lines shown in preview
                              overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // Message if no notes exist for the day
                  if (!hasAnyNotes)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Tap to add meals for this day!',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey.shade300),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget to build the daily view of meal notes (detailed view for selected day)
  Widget _buildDailyView() {
    final day = _selectedDay ?? DateTime.now();
    // Normalize the day for consistency
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    _mealNotes.putIfAbsent(normalizedDay, () => {}); // Ensure map entry exists
    final notes = _mealNotes[normalizedDay]!; // Get notes for the normalized day

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25), // Increased padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meal Plan for ${_formatDate(normalizedDay, 'EEEE, MMM d,yyyy')}', // Display formatted date
            style: const TextStyle(
                fontSize: 24, // Larger title
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
          ),
          const Divider(
              height: 30, thickness: 1.8), // Thicker, more prominent divider
          ..._meals.map((meal) {
            final text = notes[meal]?.trim();
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0), // More vertical spacing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getMealIcon(meal),
                          color: Colors.deepOrange, size: 26), // Larger icon
                      const SizedBox(width: 10),
                      Text(
                        '$meal:',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19, // Slightly larger meal title
                            color: Colors.black87),
                      ),
                      const Spacer(), // Pushes edit/delete buttons to the right
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.blueGrey, size: 22),
                        onPressed: () => _showMealNoteDialog(normalizedDay), // Open dialog to edit all meals
                        tooltip: 'Edit all meals',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 22),
                        onPressed: () => _deleteMealNote(normalizedDay, meal), // Delete specific meal note
                        tooltip: 'Delete $meal note',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity, // Take full width
                    padding: const EdgeInsets.all(15), // More padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15), // Matching border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4), // Subtle shadow
                        ),
                      ],
                      border: Border.all(
                          color: Colors.grey.shade200), // Subtle border
                    ),
                    child: Text(
                      text?.isEmpty ?? true ? 'No notes for $meal.' : text!,
                      style: TextStyle(
                          color: text?.isEmpty ?? true
                              ? Colors.grey.shade500
                              : Colors.black54, // Softer color for notes
                          fontSize: 16), // Slightly larger note text
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Widget to build the monthly calendar view
  Widget _buildMonthlyView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16), // Consistent padding
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected, // Uses the _onDaySelected method
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color:
                      Colors.deepOrange.shade400, // Slightly darker today color
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.black87),
                weekendTextStyle: const TextStyle(color: Colors.redAccent),
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Colors.teal.shade400, // Matching marker color
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
                leftChevronIcon: const Icon(Icons.chevron_left,
                    color: Colors.deepOrange, size: 28), // Larger chevrons
                rightChevronIcon: const Icon(Icons.chevron_right,
                    color: Colors.deepOrange, size: 28),
              ),
              calendarBuilders: CalendarBuilders(
                // Uses the _buildEventsMarker method to show markers on days with notes
                markerBuilder: (context, day, events) {
                  return _buildEventsMarker(day, events);
                },
                selectedBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25), // More spacing
            if (_selectedDay != null) // Only show notes if a day is selected
              Card(
                elevation: 5, // Consistent elevation with weekly view
                margin: const EdgeInsets.symmetric(
                    horizontal: 4), // Aligns with calendar width
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20)), // Consistent border radius
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Consistent padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes for ${_formatDate(_selectedDay!, 'EEE, MMM d,yyyy')}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrange),
                      ),
                      const Divider(height: 20, thickness: 1.2),
                      // Display notes for each meal type
                      ..._meals.map((meal) {
                        // Normalize the day for consistency
                        final DateTime normalizedSelectedDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                        _mealNotes.putIfAbsent(normalizedSelectedDay, () => {});
                        final text = _mealNotes[normalizedSelectedDay]![meal]?.trim();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120, // Fixed width for meal type label
                                child: Text(
                                  '$meal: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                              ),
                              Expanded( // Allows meal note text to take remaining space
                                child: Text(
                                  text?.isEmpty ?? true ? 'No notes' : text!,
                                  style: TextStyle(
                                      fontStyle: text?.isEmpty ?? true
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                      color: text?.isEmpty ?? true
                                          ? Colors.grey.shade600
                                          : Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _showMealNoteDialog(_selectedDay!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            elevation: 3,
                          ),
                          child: const Text('Edit Notes',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Very light grey background
      appBar: AppBar(
        title: const Text(
          'Meal Planner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26, // Slightly larger title
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Color(0xFFFB8C00)], // Orange gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Adds some margin
            decoration: BoxDecoration(
              // Fix for deprecated withOpacity: Use withAlpha for direct alpha control
              color: const Color(0xFFFB8C00).withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.deepOrange.shade100,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // More rounded indicator
                color: Colors.deepOrange, // Solid deep orange for selected tab
                boxShadow: [
                  BoxShadow(
                    // Fix for deprecated withOpacity: Use withAlpha for direct alpha control
                    color: Colors.deepOrange.shade900.withAlpha((255 * 0.4).round()),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              tabs: const [
                Tab(text: 'Monthly'),
                Tab(text: 'Weekly'),
                Tab(text: 'Daily'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyView(), // Call to the monthly view widget
          _buildWeeklyView(),  // Call to the weekly view widget
          _buildDailyView(),   // Call to the daily view widget
        ],
      ),
    );
  }
}
