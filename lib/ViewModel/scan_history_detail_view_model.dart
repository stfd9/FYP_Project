import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_view_model.dart';
import 'scan_history_view_model.dart';

class ScanHistoryDetailViewModel extends BaseViewModel {
  ScanHistoryItem? _item;
  bool _isSaved = false;

  ScanHistoryItem? get item => _item;
  bool get isSaved => _isSaved;

  bool get isDisease => _item?.isDisease ?? false;
  Color get accentColor =>
      isDisease ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4);
  IconData get typeIcon =>
      isDisease ? Icons.healing_rounded : Icons.pets_rounded;
  String get typeLabel =>
      isDisease ? 'Skin Disease Scan' : 'Breed Identification';
  double get confidencePercentage => (_item?.confidence ?? 0) * 100;

  void initialize(ScanHistoryItem item) {
    _item = item;
    notifyListeners();
  }

  void toggleSave() {
    _isSaved = !_isSaved;
    notifyListeners();
  }

  void shareResult(BuildContext context) {
    if (_item == null) return;

    final String shareText =
        '''
Pet Scan Result
Type: $typeLabel
Result: ${_item!.topLabel}
Confidence: ${confidencePercentage.toStringAsFixed(1)}%
Date: ${_item!.dateLabel}
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Result copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void deleteResult(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Result'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this scan result? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scan result deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void exportAsPDF(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.white),
            SizedBox(width: 8),
            Text('Exporting as PDF...'),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Simulate PDF export
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('PDF exported successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  void printResult(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.print, color: Colors.white),
            SizedBox(width: 8),
            Text('Preparing to print...'),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void viewRecommendations(BuildContext context) {
    if (_item == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.lightbulb_outline, color: accentColor),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Recommendations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Based on the scan result: ${_item!.topLabel}\n\nPlease consult with a veterinarian for professional advice.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
