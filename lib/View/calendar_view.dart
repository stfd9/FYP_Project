import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar_event.dart';
import '../ViewModel/calendar_view_model.dart';

class CalendarView extends StatelessWidget {
  // Add this variable to receive date from HomeView
  final DateTime? initialDate;

  // Update constructor
  const CalendarView({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    // --- DELETE THE MODALROUTE LINE BELOW ---
    // final initialDate = ModalRoute.of(context)?.settings.arguments as DateTime?;
    // ----------------------------------------

    return ChangeNotifierProvider(
      // Use the variable passed from the constructor
      create: (_) => CalendarViewModel(initialDate: initialDate),
      child: const _CalendarBody(),
    );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<CalendarViewModel>();
    final selectedEvent = viewModel.selectedEvent;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.addSchedule(context),
        backgroundColor: Colors.grey.shade200,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _CalendarCard(viewModel: viewModel),
              const SizedBox(height: 24),
              Text(
                'Scheduled Event',
                style: theme.textTheme.titleMedium?.copyWith(
                  letterSpacing: 1,
                  fontSize: 20,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              if (selectedEvent != null)
                _ScheduledEventCard(
                  event: selectedEvent,
                  onTap: () => viewModel.openSelectedEvent(context),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black87, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 8),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Text(
                    'No schedule for this day.\nTap + to add a new schedule.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.viewModel});

  final CalendarViewModel viewModel;

  bool _isEventDay(int day) =>
      viewModel.events.any((event) => event.day == day);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = viewModel.days;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black87, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Colors.grey.shade800, size: 32),
              Text(
                'January',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade800, size: 32),
            ],
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: days.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              if (day == null) {
                return const SizedBox.shrink();
              }
              final highlight = _isEventDay(day);
              final isSelected = day == viewModel.selectedDay;

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => viewModel.selectDay(day),
                child: Column(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      alignment: Alignment.center,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Text(
                        '$day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                    if (highlight)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }
}

class _ScheduledEventCard extends StatelessWidget {
  const _ScheduledEventCard({required this.event, this.onTap});

  final CalendarEvent event;
  final VoidCallback? onTap;

  String _ordinalDay(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black87, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 8),
              blurRadius: 14,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_ordinalDay(event.day)} Jan 2025',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.petName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(event.activity, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
