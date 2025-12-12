import 'package:flutter/material.dart';
import 'base_view_model.dart';
import 'analysis_record_view_model.dart';

class AnalysisRecordListViewModel extends BaseViewModel {
  List<AnalysisRecord> _records = [];
  List<AnalysisRecord> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Breed, Disease

  List<AnalysisRecord> get records =>
      _filteredRecords.isEmpty && _searchQuery.isEmpty
      ? _records
      : _filteredRecords;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  int get totalRecords => _records.length;
  int get breedScans => _records.where((r) => r.scanType == 'Breed').length;
  int get diseaseScans => _records.where((r) => r.scanType == 'Disease').length;

  AnalysisRecordListViewModel() {
    _loadRecords();
  }

  void _loadRecords() {
    // Initialize with sample data
    _records = [
      AnalysisRecord(
        id: '1',
        userName: 'User 1',
        userEmail: 'user1@example.com',
        scanType: 'Breed',
        result: 'Golden Retriever',
        confidence: 0.95,
        date: '10/12/2025 14:30',
        imageUrl: 'assets/sample_dog.jpg',
      ),
      AnalysisRecord(
        id: '2',
        userName: 'User 2',
        userEmail: 'user2@example.com',
        scanType: 'Skin Disease',
        result: 'Ringworm',
        confidence: 0.87,
        date: '09/12/2025 10:15',
        imageUrl: 'assets/sample_skin.jpg',
      ),
      AnalysisRecord(
        id: '3',
        userName: 'User 3',
        userEmail: 'user3@example.com',
        scanType: 'Breed',
        result: 'Labrador',
        confidence: 0.92,
        date: '08/12/2025 16:45',
        imageUrl: 'assets/sample_dog2.jpg',
      ),
      AnalysisRecord(
        id: '4',
        userName: 'User 4',
        userEmail: 'user4@example.com',
        scanType: 'Skin Disease',
        result: 'Hot Spot',
        confidence: 0.78,
        date: '07/12/2025 09:20',
        imageUrl: 'assets/sample_skin2.jpg',
      ),
      AnalysisRecord(
        id: '5',
        userName: 'User 5',
        userEmail: 'user5@example.com',
        scanType: 'Breed',
        result: 'Beagle',
        confidence: 0.89,
        date: '06/12/2025 13:10',
        imageUrl: 'assets/sample_dog3.jpg',
      ),
    ];
    _filteredRecords = List.from(_records);
    notifyListeners();
  }

  void searchRecords(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredRecords = _records.where((record) {
      // Apply search filter
      final matchesSearch =
          _searchQuery.isEmpty ||
          record.result.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record.scanType.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply type filter
      final matchesType =
          _selectedFilter == 'All' || record.scanType == _selectedFilter;

      return matchesSearch && matchesType;
    }).toList();

    notifyListeners();
  }

  void sortByDate({bool ascending = false}) {
    _filteredRecords.sort((a, b) {
      final comparison = a.date.compareTo(b.date);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  void sortByConfidence({bool ascending = false}) {
    _filteredRecords.sort((a, b) {
      final comparison = a.confidence.compareTo(b.confidence);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  void openRecordDetail(BuildContext context, AnalysisRecord record) {
    Navigator.pushNamed(context, '/analysis_record_detail', arguments: record);
  }

  void deleteRecord(BuildContext context, AnalysisRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Record'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete the ${record.scanType} scan for "${record.result}"?',
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
              _records.removeWhere((r) => r.id == record.id);
              _applyFilters();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Record deleted successfully'),
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

  void shareRecord(BuildContext context, AnalysisRecord record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${record.result} scan result...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void exportAllRecords(BuildContext context) {
    if (_records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No records to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_records.length} records...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Simulate export
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Records exported successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void clearAllRecords(BuildContext context) {
    if (_records.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Clear All Records'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete all ${_records.length} records? This action cannot be undone.',
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
              _records.clear();
              _filteredRecords.clear();
              notifyListeners();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All records cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
