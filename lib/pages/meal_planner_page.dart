import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// MealPlannerPage is a stateful widget that provides a meal planning interface
/// with three tabs: Monthly, Weekly, and Daily. Users can add, edit, and view
/// meal notes for each day and meal type. The UI adapts to light/dark mode.
class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage>
    with SingleTickerProviderStateMixin {
  // The currently focused day in the calendar
  DateTime _focusedDay = DateTime.now();
  // The currently selected day for editing/viewing notes
  DateTime? _selectedDay;
  // List of meal types for each day
  final List<String> _meals = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Additional Meal'
  ];
  // Stores meal notes for each day and meal type
  Map<DateTime, Map<String, String>> _mealNotes = {};
  // Tab controller for switching between Monthly, Weekly, and Daily views
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay;

    // When switching tabs, update the selected day if needed
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
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

  /// Called when a day is selected in the calendar.
  /// Updates the selected and focused day, switches to Daily tab, and opens the note dialog.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _tabController.animateTo(2); // Switch to Daily tab
    _showMealNoteDialog(selectedDay);
  }

  /// Returns an icon for each meal type.
  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.egg_alt_outlined;
      case 'Lunch':
        return Icons.lunch_dining_outlined;
      case 'Dinner':
        return Icons.dinner_dining_outlined;
      case 'Additional Meal':
        return Icons.restaurant_menu;
      default:
        return Icons.restaurant_menu;
    }
  }

  /// Shows a dialog to add or edit meal notes for a specific day.
  void _showMealNoteDialog(DateTime day) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _mealNotes.putIfAbsent(day, () => {});

    // Create controllers for each meal's note input
    Map<String, TextEditingController> controllers = {
      for (var meal in _meals)
        meal: TextEditingController(text: _mealNotes[day]![meal] ?? '')
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            theme.dialogTheme.backgroundColor ?? colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Meal Notes (${_formatDate(day, 'EEE, MMM d,yyyy')})',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: colorScheme.primary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _meals.map((meal) {
              // Input for each meal note
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controllers[meal],
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: meal,
                    labelStyle: TextStyle(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                    floatingLabelStyle: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor ??
                        (theme.brightness == Brightness.dark
                            ? colorScheme.surface
                            : Colors.grey.shade100),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              for (var controller in controllers.values) {
                controller.dispose();
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.textTheme.bodyLarge?.color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Cancel'),
          ),
          // Save button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mealNotes.putIfAbsent(day, () => {});
                for (var meal in _meals) {
                  _mealNotes[day]![meal] = controllers[meal]!.text.trim();
                }
                // Remove the day if all notes are empty
                if (_mealNotes[day]!.values.every((note) => note.isEmpty)) {
                  _mealNotes.remove(day);
                }
              });
              for (var controller in controllers.values) {
                controller.dispose();
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 3,
            ),
            child: Text(
              'Save',
              style: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to confirm and delete a meal note for a specific meal and day.
  void _deleteMealNote(DateTime day, String mealType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            theme.dialogTheme.backgroundColor ?? colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Meal Note',
            style: TextStyle(color: colorScheme.primary)),
        content: Text(
            'Are you sure you want to delete the $mealType note for ${_formatDate(day, 'EEE, MMM d,yyyy')}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
                foregroundColor: theme.textTheme.bodyLarge?.color),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_mealNotes.containsKey(day)) {
                  _mealNotes[day]!.remove(mealType);
                  if (_mealNotes[day]!
                      .values
                      .every((note) => note.trim().isEmpty)) {
                    _mealNotes.remove(day);
                  }
                }
              });
              Navigator.of(context).pop();
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

  /// Builds a small marker on the calendar for days that have meal notes.
  Widget _buildEventsMarker(DateTime day, List events) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_mealNotes[day] == null ||
        _mealNotes[day]!.values.every((note) => note.trim().isEmpty)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 2,
      child: GestureDetector(
        onTap: () => _showMealSummary(day),
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.secondary,
            boxShadow: [
              BoxShadow(
                color: colorScheme.secondary.withOpacity(0.5),
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a bottom sheet with a summary of all meal notes for a given day.
  void _showMealSummary(DateTime day) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notes = _mealNotes[day];
    if (notes == null || notes.values.every((note) => note.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No meal notes for this day.'),
          backgroundColor: colorScheme.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          theme.bottomSheetTheme.backgroundColor ?? colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Meal Summary for ${_formatDate(day, 'EEEE, MMM d,yyyy')}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: colorScheme.primary),
                ),
                Divider(height: 30, thickness: 1.2, color: theme.dividerColor),
                // List of meal notes
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: _meals.map((meal) {
                      final text = notes[meal]?.trim();
                      if (text == null || text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        color: theme.cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$meal:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: colorScheme.onSurface),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                text,
                                style: TextStyle(
                                    fontSize: 15.5,
                                    color: theme.textTheme.bodyMedium?.color),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                // Close button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
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

  /// Formats a DateTime object to a string using the given format.
  String _formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  /// Returns a list of DateTime objects representing the current week.
  List<DateTime> _getCurrentWeekDates(DateTime selectedDay) {
    final weekday = selectedDay.weekday;
    final startOfWeek = selectedDay.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  /// Builds the Weekly view tab, showing cards for each day of the week.
  Widget _buildWeeklyView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final weekDates = _getCurrentWeekDates(_selectedDay ?? DateTime.now());
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weekDates.length,
      itemBuilder: (context, index) {
        final day = weekDates[index];
        _mealNotes.putIfAbsent(day, () => {});
        final notes = _mealNotes[day]!;

        final bool hasAnyNotes =
            notes.values.any((note) => note.trim().isNotEmpty);

        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          color: theme.cardColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showMealNoteDialog(day),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day title
                  Text(
                    _formatDate(day, 'EEEE, MMMM d,yyyy'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: colorScheme.primary),
                  ),
                  Divider(
                      height: 20, thickness: 1.2, color: theme.dividerColor),
                  // List of meals for the day
                  ..._meals.map((meal) {
                    final text = notes[meal]?.trim();
                    final bool isEmpty = text?.isEmpty ?? true;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Meal name
                          SizedBox(
                            width: 120,
                            child: Text(
                              '$meal: ',
                              style: TextStyle(
                                fontWeight:
                                    isEmpty ? FontWeight.w600 : FontWeight.w600,
                                fontStyle: isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontSize: 16,
                                color: isEmpty
                                    ? (isDark
                                        ? theme.hintColor
                                        : Colors.grey[700])
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Meal note or "No notes"
                          Expanded(
                            child: Text(
                              isEmpty ? 'No notes' : text!,
                              style: TextStyle(
                                fontStyle: isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontWeight: isEmpty
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 16,
                                color: isEmpty
                                    ? (isDark
                                        ? theme.hintColor
                                        : Colors.grey[700])
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // If no notes at all, show a prompt
                  if (!hasAnyNotes)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Tap to add meals for this day!',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDark ? theme.hintColor : Colors.grey[700],
                        ),
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

  /// Builds the Daily view tab, showing meal notes for the selected day.
  Widget _buildDailyView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final day = _selectedDay ?? DateTime.now();
    _mealNotes.putIfAbsent(day, () => {});
    final notes = _mealNotes[day]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day title
          Text(
            'Meal Plan for ${_formatDate(day, 'EEEE, MMMM d,yyyy')}',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary),
          ),
          Divider(height: 30, thickness: 1.8, color: theme.dividerColor),
          // List of meals for the day
          ..._meals.map((meal) {
            final text = notes[meal]?.trim();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getMealIcon(meal),
                          color: colorScheme.primary, size: 26),
                      const SizedBox(width: 10),
                      Text(
                        '$meal:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: colorScheme.onSurface),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit_outlined,
                            color: theme.iconTheme.color, size: 22),
                        onPressed: () => _showMealNoteDialog(day),
                        tooltip: 'Edit all meals',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 22),
                        onPressed: () => _deleteMealNote(day, meal),
                        tooltip: 'Delete $meal note',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      text?.isEmpty ?? true ? 'No notes for $meal.' : text!,
                      style: TextStyle(
                          color: text?.isEmpty ?? true
                              ? (theme.brightness == Brightness.dark
                                  ? theme.hintColor
                                  : Colors.grey[800])
                              : theme.textTheme.bodyMedium?.color,
                          fontSize: 16),
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

  /// Builds the Monthly view tab, showing a calendar and notes for the selected day.
  Widget _buildMonthlyView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Calendar widget
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                weekendTextStyle: TextStyle(color: colorScheme.error),
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary),
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: colorScheme.primary, size: 28),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: colorScheme.primary, size: 28),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  return _buildEventsMarker(day, events);
                },
                selectedBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            // Notes for the selected day
            if (_selectedDay != null)
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: theme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes for ${_formatDate(_selectedDay!, 'EEE, MMMM d,yyyy')}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: colorScheme.primary),
                      ),
                      Divider(
                          height: 20,
                          thickness: 1.2,
                          color: theme.dividerColor),
                      ..._meals.map((meal) {
                        _mealNotes.putIfAbsent(_selectedDay!, () => {});
                        final text = _mealNotes[_selectedDay!]![meal]?.trim();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '$meal: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: colorScheme.onSurface),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  text?.isEmpty ?? true ? 'No notes' : text!,
                                  style: TextStyle(
                                      fontStyle: text?.isEmpty ?? true
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                      color: text?.isEmpty ?? true
                                          ? (theme.brightness == Brightness.dark
                                              ? theme.hintColor
                                              : Colors.grey[800])
                                          : theme.textTheme.bodyMedium?.color),
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
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            elevation: 3,
                          ),
                          child: Text('Edit Notes',
                              style: TextStyle(
                                  color: colorScheme.onPrimary, fontSize: 16)),
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

  /// Helper to check if two DateTime objects are the same day.
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Main build method for the Meal Planner page.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Meal Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [colorScheme.primary, colorScheme.secondary]
                  : [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surface.withOpacity(0.2)
                  : Colors.deepOrange.shade700.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: isDark
                  ? colorScheme.onSurface.withOpacity(0.7)
                  : Colors.deepOrange.shade100,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
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
          _buildMonthlyView(),
          _buildWeeklyView(),
          _buildDailyView(),
        ],
      ),
    );
  }
}
