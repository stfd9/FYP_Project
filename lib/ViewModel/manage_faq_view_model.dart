import 'package:flutter/material.dart';
import 'base_view_model.dart';

class ManageFAQViewModel extends BaseViewModel {
  // Dummy Initial Data
  final List<FAQItem> _faqs = [
    FAQItem(
      id: '1',
      question: 'How do I scan my pet?',
      answer:
          'Go to the Scan tab, choose "Skin" or "Breed", and take a clear photo.',
    ),
    FAQItem(
      id: '2',
      question: 'Is the diagnosis 100% accurate?',
      answer:
          'No, this is an AI aid. Please consult a vet for a medical diagnosis.',
    ),
    FAQItem(
      id: '3',
      question: 'Can I add multiple pets?',
      answer: 'Yes! Go to the "Pets" tab and click the + button.',
    ),
  ];

  List<FAQItem> get faqs => List.unmodifiable(_faqs);

  // --- CRUD OPERATIONS ---

  void addFAQ(String question, String answer) {
    final newFAQ = FAQItem(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // Simple ID generation
      question: question,
      answer: answer,
    );
    _faqs.add(newFAQ);
    notifyListeners();
  }

  void editFAQ(String id, String newQuestion, String newAnswer) {
    final index = _faqs.indexWhere((f) => f.id == id);
    if (index != -1) {
      _faqs[index] = FAQItem(id: id, question: newQuestion, answer: newAnswer);
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

class FAQItem {
  final String id;
  final String question;
  final String answer;

  FAQItem({required this.id, required this.question, required this.answer});
}
