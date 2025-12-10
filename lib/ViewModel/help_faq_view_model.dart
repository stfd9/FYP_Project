import 'base_view_model.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class HelpFaqViewModel extends BaseViewModel {
  final List<FaqItem> _items = const [
    FaqItem(
      question: 'How do I scan my pet’s skin?',
      answer:
          'Go to the Scan tab and capture or upload a clear, well-lit photo of the area you want to analyse.',
    ),
    FaqItem(
      question: 'Can I add more than one pet?',
      answer:
          'Yes. Go to the Pets tab and tap “Add pet” to create extra profiles.',
    ),
    FaqItem(
      question: 'How do reminders work?',
      answer:
          'Set medication or vaccination schedules in the Calendar tab. Notifications follow your reminder preferences.',
    ),
  ];

  List<FaqItem> get items => List.unmodifiable(_items);
}
