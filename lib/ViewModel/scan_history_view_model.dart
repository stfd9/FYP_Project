import 'package:flutter/material.dart';

import '../scan_type.dart';
import 'base_view_model.dart';

class ScanHistoryItem {
  const ScanHistoryItem({
    required this.type,
    required this.topLabel,
    required this.confidence,
    required this.dateLabel,
  });

  final ScanType type;
  final String topLabel;
  final double confidence;
  final String dateLabel;

  bool get isDisease => type == ScanType.skinDisease;
}

class ScanHistoryViewModel extends BaseViewModel {
  final List<ScanHistoryItem> _history = const [
    ScanHistoryItem(
      type: ScanType.skinDisease,
      topLabel: 'Healthy skin',
      confidence: 0.98,
      dateLabel: 'Today · 2:15 PM',
    ),
    ScanHistoryItem(
      type: ScanType.breed,
      topLabel: 'Domestic Shorthair',
      confidence: 0.72,
      dateLabel: 'Yesterday · 9:40 PM',
    ),
    ScanHistoryItem(
      type: ScanType.skinDisease,
      topLabel: 'Mild irritation',
      confidence: 0.65,
      dateLabel: '24 Nov 2025 · 8:05 PM',
    ),
  ];

  List<ScanHistoryItem> get history => List.unmodifiable(_history);

  bool get hasHistory => _history.isNotEmpty;

  void openHistoryItem(BuildContext context, ScanHistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detailed results for ${item.topLabel} coming soon.'),
      ),
    );
  }
}
