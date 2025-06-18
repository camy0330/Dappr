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
  Map<DateTime, Map<String, String>> _mealNotes = {};
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay;

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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _tabController.animateTo(2); // Index 2 is the 'Daily' tab
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
        return Icons.restaurant_menu; // Updated icon
      default:
        return Icons.restaurant_menu;
    }
  }

  void _showMealNoteDialog(DateTime day) {
    _mealNotes.putIfAbsent(day, () => {});

    Map<String, TextEditingController> controllers = {
      for (var meal in _meals)
        meal: TextEditingController(text: _mealNotes[day]![meal] ?? '')
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // More rounded
        title: Text(
          'Add Meal Notes (${_formatDate(day, 'EEE, MMM d,yyyy')})',
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
                    fillColor: Colors.grey.shade100, // Light fill color
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  maxLines:
                      2, // Adjusted: Reduced maxLines to make the boxes shorter
                  textCapitalization: TextCapitalization.sentences,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              for (var controller in controllers.values) {
                controller.dispose();
              }
              Navigator.of(context).pop();
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
                _mealNotes.putIfAbsent(day, () => {});
                for (var meal in _meals) {
                  _mealNotes[day]![meal] = controllers[meal]!.text.trim();
                }
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

  void _deleteMealNote(DateTime day, String mealType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Meal Note',
            style: TextStyle(color: Colors.deepOrange)),
        content: Text(
            'Are you sure you want to delete the $mealType note for ${_formatDate(day, 'EEE, MMM d,yyyy')}?'),
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

  Widget _buildEventsMarker(DateTime day, List events) {
    if (_mealNotes[day] == null ||
        _mealNotes[day]!.values.every((note) => note.trim().isEmpty)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 2, // Adjust position
      child: GestureDetector(
        onTap: () => _showMealSummary(day),
        child: Container(
          width: 7, // Slightly smaller
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal.shade400, // Softer teal
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.teal.shade200.withOpacity(0.5),
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMealSummary(DateTime day) {
    final notes = _mealNotes[day];
    if (notes == null || notes.values.every((note) => note.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No meal notes for this day.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(30)), // More pronounced curve
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8, // Allow it to expand more
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(25), // Increased padding
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
                  'Meal Summary for ${_formatDate(day, 'EEEE, MMM d,yyyy')}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.deepOrange),
                ),
                const Divider(
                    height: 30,
                    thickness: 1.2,
                    color: Colors.grey), // Thicker divider
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: _meals.map((meal) {
                      final text = notes[meal]?.trim();
                      if (text == null || text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Card(
                        margin:
                            const EdgeInsets.only(bottom: 15), // More spacing
                        elevation: 2, // Subtle elevation
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15)), // Matching card radius
                        child: Padding(
                          padding:
                              const EdgeInsets.all(15), // Increased padding
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

  String _formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  List<DateTime> _getCurrentWeekDates(DateTime selectedDay) {
    final weekday = selectedDay.weekday;
    final startOfWeek = selectedDay.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  Widget _buildWeeklyView() {
    final weekDates = _getCurrentWeekDates(_selectedDay ?? DateTime.now());
    return ListView.builder(
      padding: const EdgeInsets.all(16), // Increased padding
      itemCount: weekDates.length,
      itemBuilder: (context, index) {
        final day = weekDates[index];
        _mealNotes.putIfAbsent(day, () => {});
        final notes = _mealNotes[day]!;

        final bool hasAnyNotes =
            notes.values.any((note) => note.trim().isNotEmpty);

        return Card(
          elevation: 5, // Increased elevation for a floating effect
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // More rounded
          margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 4), // More vertical margin
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showMealNoteDialog(day),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(day, 'EEEE, MMMM d,yyyy'),
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
                            width: 120,
                            child: Text(
                              '$meal: ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87),
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
                                      ? Colors.grey.shade600
                                      : Colors.black54), // Softer text color
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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

  Widget _buildDailyView() {
    final day = _selectedDay ?? DateTime.now();
    _mealNotes.putIfAbsent(day, () => {});
    final notes = _mealNotes[day]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25), // Increased padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Corrected date format here for the Daily View
            'Meal Plan for ${_formatDate(day, 'EEEE, MMMM d,yyyy')}',
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
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.blueGrey, size: 22),
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
              onDaySelected: _onDaySelected,
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
            if (_selectedDay != null)
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
                        // Fixed the date format here:
                        'Notes for ${_formatDate(_selectedDay!, 'EEE, MMMM d,yyyy')}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrange),
                      ),
                      const Divider(height: 20, thickness: 1.2),
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black87),
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
        backgroundColor: Colors.deepOrange, // Solid deep orange background
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Adds some margin
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade700
                  // ignore: deprecated_member_use
                  .withOpacity(0.2), // Subtle background for tabs
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
                    // ignore: deprecated_member_use
                    color: Colors.deepOrange.shade900.withOpacity(0.4),
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
