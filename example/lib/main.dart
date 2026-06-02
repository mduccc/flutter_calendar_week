import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CalendarWeek',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
          ),
        ),
        home: const HomePage(),
      );
}

class _Event {
  final String title;
  final String time;
  final Color color;
  const _Event(this.title, this.time, this.color);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalendarWeekController _controller = CalendarWeekController();
  bool _scrollEnabled = true;

  static const _primary = Color(0xFF2563EB);

  final Map<int, List<_Event>> _eventsByOffset = {
    0: [
      const _Event('Team standup', '9:00 AM', Color(0xFF3B82F6)),
      const _Event('Design review', '2:00 PM', Color(0xFFF59E0B)),
    ],
    1: [
      const _Event('Client call', '11:00 AM', Color(0xFF10B981)),
    ],
    3: [
      const _Event('Sprint planning', '10:00 AM', Color(0xFFEF4444)),
      const _Event('Lunch with team', '12:30 PM', Color(0xFFF59E0B)),
      const _Event('Code review', '4:00 PM', Color(0xFF3B82F6)),
    ],
  };

  List<_Event> get _selectedEvents {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final sel = _controller.selectedDate;
    final selOnly = DateTime(sel.year, sel.month, sel.day);
    final diff = selOnly.difference(todayOnly).inDays;
    return _eventsByOffset[diff] ?? [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My Calendar',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() => _scrollEnabled = !_scrollEnabled),
              icon: Icon(_scrollEnabled ? Icons.lock_open_rounded : Icons.lock_rounded),
              tooltip: _scrollEnabled ? 'Disable swipe' : 'Enable swipe',
            ),
            IconButton(
              onPressed: () {
                _controller.jumpToDate(DateTime.now());
                setState(() {});
              },
              icon: const Icon(Icons.today_rounded),
              tooltip: 'Jump to today',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CalendarHeader(
              controller: _controller,
              scrollEnabled: _scrollEnabled,
              onChanged: () => setState(() {}),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: _DateHeading(
                date: _controller.selectedDate,
                eventCount: _selectedEvents.length,
              ),
            ),
            Expanded(child: _EventsList(events: _selectedEvents)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _controller.jumpToDate(DateTime.now());
            setState(() {});
          },
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.today_rounded),
          label: const Text('Today', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      );
}

class _CalendarHeader extends StatelessWidget {
  final CalendarWeekController controller;
  final bool scrollEnabled;
  final VoidCallback onChanged;

  static const _primary = Color(0xFF2563EB);
  static const _todayGreen = Color(0xFF10B981);

  const _CalendarHeader({
    required this.controller,
    required this.scrollEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            CalendarWeek(
              controller: controller,
              height: 110,
              showMonth: true,
              backgroundColor: Colors.transparent,
              physics: scrollEnabled ? null : const NeverScrollableScrollPhysics(),
              minDate: DateTime.now().add(const Duration(days: -365)),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              dayOfWeekStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              weekendsStyle: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              dateStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              todayDateStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              todayBackgroundColor: _todayGreen,
              pressedDateBackgroundColor: Colors.white24,
              pressedDateStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              onDatePressed: (_) => onChanged(),
              onDateLongPressed: (_) {},
              onWeekChanged: onChanged,
              monthViewBuilder: (DateTime time) => Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  DateFormat.yMMMM().format(time),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              decorations: [
                DecorationItem(
                  decorationAlignment: FractionalOffset.bottomCenter,
                  date: DateTime.now().add(const Duration(days: 3)),
                  decoration: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 4,
              top: 2,
              child: _CircleNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: () {
                  controller.previousWeek();
                  onChanged();
                },
              ),
            ),
            Positioned(
              right: 4,
              top: 2,
              child: _CircleNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: () {
                  controller.nextWeek();
                  onChanged();
                },
              ),
            ),
          ],
        ),
      );
}

class _CircleNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white12,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      );
}

class _DateHeading extends StatelessWidget {
  final DateTime date;
  final int eventCount;

  static const _primary = Color(0xFF2563EB);

  const _DateHeading({required this.date, required this.eventCount});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(date),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMMM d, y').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$eventCount event${eventCount == 1 ? '' : 's'}',
              style: const TextStyle(
                color: _primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}

class _EventsList extends StatelessWidget {
  final List<_Event> events;

  const _EventsList({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_available_rounded, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No events',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _EventCard(event: events[i]),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      event.time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: event.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.chevron_right_rounded, color: event.color, size: 20),
            ),
          ],
        ),
      );
}
