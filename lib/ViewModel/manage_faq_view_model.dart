import 'package:flutter/material.dart';
import 'base_view_model.dart';

// 1. Data Model for the FAQ content
class AdminFaqItem {
  final String id;
  final String question;
  final String answer;
  final String categoryTitle; // Links to the category definition

  AdminFaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryTitle,
  });
}

// 2. Data Model for the Visual Category (Icon, Color, etc.)
class FaqCategoryDef {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;

  FaqCategoryDef({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class ManageFAQViewModel extends BaseViewModel {
  // --- A. DEFINITIONS: Visual Style for Categories ---
  final List<FaqCategoryDef> _categoryDefinitions = [
    FaqCategoryDef(
      title: 'Breed Identifier',
      icon: Icons.pets,
      color: Colors.orange,
      bgColor: const Color(0xFFFFF3E0),
    ),
    FaqCategoryDef(
      title: 'Skin Disease Identifier',
      icon: Icons.healing,
      color: Colors.red,
      bgColor: const Color(0xFFFFEBEE),
    ),
    FaqCategoryDef(
      title: 'Schedule & Reminders',
      icon: Icons.calendar_today,
      color: Colors.blue,
      bgColor: const Color(0xFFE3F2FD),
    ),
    FaqCategoryDef(
      title: 'Pet Profiles',
      icon: Icons.badge_outlined,
      color: Colors.purple,
      bgColor: const Color(0xFFF3E5F5),
    ),
    FaqCategoryDef(
      title: 'Account & Security',
      icon: Icons.security,
      color: Colors.teal,
      bgColor: const Color(0xFFE0F2F1),
    ),
    // --- NEW CATEGORY REQUESTED ---
    FaqCategoryDef(
      title: 'General Questions',
      icon: Icons.help_outline,
      color: Colors.indigo,
      bgColor: const Color(0xFFE8EAF6),
    ),
  ];

  // --- B. DATA: The Actual FAQs ---
  final List<AdminFaqItem> _faqs = [
    AdminFaqItem(
      id: '1',
      question: 'How do I scan my pet?',
      answer:
          'Go to the Scan tab, choose "Skin" or "Breed", and take a clear photo.',
      categoryTitle: 'Breed Identifier',
    ),
    AdminFaqItem(
      id: '2',
      question: 'Is the diagnosis 100% accurate?',
      answer:
          'No, this is an AI aid. Please consult a vet for a medical diagnosis.',
      categoryTitle: 'Skin Disease Identifier',
    ),
    AdminFaqItem(
      id: '3',
      question: 'How do I contact support?',
      answer: 'You can email us at support@pawscope.com.',
      categoryTitle: 'General Questions',
    ),
  ];

  // Getters
  List<FaqCategoryDef> get categoryDefinitions =>
      List.unmodifiable(_categoryDefinitions);
  List<AdminFaqItem> get faqs => List.unmodifiable(_faqs);

  // Helper to get FAQs for a specific category
  List<AdminFaqItem> getFaqsByCategory(String categoryTitle) {
    return _faqs.where((faq) => faq.categoryTitle == categoryTitle).toList();
  }

  // --- CRUD OPERATIONS ---

  void addFAQ(String question, String answer, String categoryTitle) {
    final newFAQ = AdminFaqItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      answer: answer,
      categoryTitle: categoryTitle,
    );
    _faqs.add(newFAQ);
    notifyListeners();
  }

  void editFAQ(
    String id,
    String newQuestion,
    String newAnswer,
    String newCategoryTitle,
  ) {
    final index = _faqs.indexWhere((f) => f.id == id);
    if (index != -1) {
      _faqs[index] = AdminFaqItem(
        id: id,
        question: newQuestion,
        answer: newAnswer,
        categoryTitle: newCategoryTitle,
      );
      notifyListeners();
    }
  }

  void deleteFAQ(BuildContext context, String id) {
    _faqs.removeWhere((f) => f.id == id);
    notifyListeners();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('FAQ deleted successfully')));
  }
}
