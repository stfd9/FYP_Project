import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar_event.dart';
import '../ViewModel/calendar_view_model.dart';

class CalendarView extends StatelessWidget {
  // 1. Receive the date from the parent (HomeView)
  final DateTime? initialDate;

  // 2. Update constructor to accept it
  const CalendarView({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 3. Use the 'initialDate' variable passed from HomeView
      create: (_) => CalendarViewModel(initialDate: initialDate),
      child: const _CalendarBody(),
    );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<CalendarViewModel>();
    final selectedEvent = viewModel.selectedEvent;

    return Stack(
      children: [
        Container(
          color: const Color(0xFFF5F6FA),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Calendar',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Calendar card
                  _CalendarCard(viewModel: viewModel),

                  const SizedBox(height: 20),

                  // Monthly Overview Title
                  Text(
                    'Monthly Overview',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Month Stats Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.1),
                          colorScheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MonthStat(
                          icon: Icons.event,
                          value: '${viewModel.totalEventsThisMonth}',
                          label: 'Events',
                          color: colorScheme.primary,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                        _MonthStat(
                          icon: Icons.upcoming,
                          value: '${viewModel.upcomingEvents}',
                          label: 'Upcoming',
                          color: const Color(0xFF4ECDC4),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                        _MonthStat(
                          icon: Icons.pets,
                          value: '${viewModel.petsWithEvents}',
                          label: 'Pets',
                          color: const Color(0xFFFF6B6B),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Scheduled Event section
                  Text(
                    'Scheduled Event',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedEvent != null)
                    _ScheduledEventCard(
                      event: selectedEvent,
                      onTap: () =>
                          viewModel.onOpenSelectedEventPressed(context),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No schedule for this day',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap + to add a new schedule',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () => viewModel.onAddSchedulePressed(context),
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }
}

// Month Stat Widget
class _MonthStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MonthStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// ... Use the same _CalendarCard and _ScheduledEventCard classes as before ...
// (I have omitted them here to save space, but you must keep them in the file)
class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.viewModel});

  final CalendarViewModel viewModel;

  bool _isEventDay(int day) => viewModel.isEventDay(day);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final days = viewModel.days;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Blue gradient header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: viewModel.goToPreviousMonth,
                ),
                Row(
                  children: [
                    const Icon(Icons.pets, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.monthYearLabel,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: viewModel.goToNextMonth,
                ),
              ],
            ),
          ),
          // Calendar body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _WeekdayLabel(label: 'Mon'),
                    _WeekdayLabel(label: 'Tue'),
                    _WeekdayLabel(label: 'Wed'),
                    _WeekdayLabel(label: 'Thu'),
                    _WeekdayLabel(label: 'Fri'),
                    _WeekdayLabel(label: 'Sat'),
                    _WeekdayLabel(label: 'Sun'),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  itemCount: days.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final day = days[index];
                    if (day == null) {
                      return const SizedBox.shrink();
                    }
                    final hasEvent = _isEventDay(day);
                    final hasActiveEvent = viewModel.hasActiveEvent(day);
                    final completedOnly = viewModel.hasCompletedOnlyEvent(day);
                    final isSelected = day == viewModel.selectedDay;
                    final now = DateTime.now();
                    final isToday =
                        day == now.day &&
                        viewModel.currentMonth == now.month &&
                        viewModel.currentYear == now.year;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => viewModel.selectDay(day),
                      child: isSelected
                          ? _PawSelectedDay(
                              day: day,
                              hasEvent: hasEvent,
                              indicatorColor: completedOnly
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: isToday
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                border: isToday
                                    ? Border.all(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '$day',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  if (hasEvent)
                                    Positioned(
                                      bottom: 4,
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: completedOnly
                                              ? Colors.grey.shade300
                                              : (hasActiveEvent
                                                    ? colorScheme.error
                                                    : Colors.grey.shade300),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Paw-shaped selected day widget
class _PawSelectedDay extends StatelessWidget {
  final int day;
  final bool hasEvent;
  final Color indicatorColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PawSelectedDay({
    required this.day,
    required this.hasEvent,
    required this.indicatorColor,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Paw shape background
        CustomPaint(
          size: const Size(44, 44),
          painter: _PawPainter(color: colorScheme.primary),
        ),
        // Day number
        Text(
          '$day',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Event indicator
        if (hasEvent)
          Positioned(
            bottom: 2,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// Custom painter for paw shape
class _PawPainter extends CustomPainter {
  final Color color;

  _PawPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Main pad (large rounded shape at bottom)
    // Using a rounded rect or oval for the main pad
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.52),
        width: w * 0.52,
        height: h * 0.48,
      ),
      paint,
    );

    // Helper to draw rotated toe pads
    void drawToe(
      double x,
      double y,
      double width,
      double height,
      double angle,
    ) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: width, height: height),
        paint,
      );
      canvas.restore();
    }

    // Toe dimensions
    final toeW = w * 0.15;
    final toeH = h * 0.22;

    // 1. Far Left Toe
    drawToe(w * 0.20, h * 0.25, toeW, toeH, -0.4);

    // 2. Mid Left Toe
    drawToe(w * 0.38, h * 0.10, toeW, toeH, -0.15);

    // 3. Mid Right Toe
    drawToe(w * 0.62, h * 0.10, toeW, toeH, 0.15);

    // 4. Far Right Toe
    drawToe(w * 0.80, h * 0.25, toeW, toeH, 0.4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

// Upcoming Event Card Widget

class _ScheduledEventCard extends StatelessWidget {
  const _ScheduledEventCard({required this.event, this.onTap});

  final CalendarEvent event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final petLabel = event.petName.trim().isEmpty ? 'No Pet' : event.petName;
    final isCompleted = event.isCompleted;
    final cardBackground = isCompleted ? Colors.grey.shade100 : Colors.white;
    final primaryTextColor = isCompleted
        ? Colors.grey.shade600
        : (textTheme.titleMedium?.color ?? Colors.black);
    final secondaryTextColor = isCompleted
        ? Colors.grey.shade500
        : Colors.grey.shade700;
    final iconColor = isCompleted ? Colors.grey.shade400 : colorScheme.primary;
    final accentColor = isCompleted
        ? Colors.grey.shade300
        : colorScheme.primary.withValues(alpha: 0.1);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pets, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.activity,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    petLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.time,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
