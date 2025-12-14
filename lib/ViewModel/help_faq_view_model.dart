import 'package:flutter/material.dart';

import 'base_view_model.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqCategory {
  const FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<FaqItem> items;
}

class HelpFaqViewModel extends BaseViewModel {
  final List<FaqCategory> _categories = [
    FaqCategory(
      title: 'Breed Identifier',
      icon: Icons.pets,
      color: Colors.orange,
      bgColor: const Color(0xFFFFF3E0),
      items: const [
        FaqItem(
          question: 'How do I identify my pet\'s breed?',
          answer:
              'Go to the Scan tab, select "Breed Identifier", and take a clear photo of your pet. Our AI will analyze the image and provide breed information.',
        ),
        FaqItem(
          question: 'How accurate is the breed identification?',
          answer:
              'Our AI model has been trained on thousands of pet images and typically achieves 90%+ accuracy for common breeds. Mixed breeds may show multiple possible matches.',
        ),
        FaqItem(
          question: 'Can I identify mixed breeds?',
          answer:
              'Yes! The system will show you the most likely breed combinations and their percentages for mixed breed pets.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Skin Disease Identifier',
      icon: Icons.healing,
      color: Colors.red,
      bgColor: const Color(0xFFFFEBEE),
      items: const [
        FaqItem(
          question: 'How do I scan for skin conditions?',
          answer:
              'Navigate to the Scan tab, select "Skin Disease", and capture a clear, well-lit photo of the affected area. Ensure good lighting for best results.',
        ),
        FaqItem(
          question: 'Is this a replacement for veterinary care?',
          answer:
              'No. This tool provides preliminary information only. Always consult a licensed veterinarian for proper diagnosis and treatment of any health concerns.',
        ),
        FaqItem(
          question: 'What skin conditions can be detected?',
          answer:
              'The scanner can identify common conditions like allergies, infections, parasites, and rashes. It will recommend veterinary consultation for serious conditions.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Schedule & Reminders',
      icon: Icons.calendar_today,
      color: Colors.blue,
      bgColor: const Color(0xFFE3F2FD),
      items: const [
        FaqItem(
          question: 'How do I set up reminders?',
          answer:
              'Go to the Calendar tab and tap the "+" button to add a new event. You can set reminders for vaccinations, medications, vet appointments, and more.',
        ),
        FaqItem(
          question: 'Can I set recurring reminders?',
          answer:
              'Yes! When creating a reminder, you can set it to repeat daily, weekly, monthly, or at custom intervals.',
        ),
        FaqItem(
          question: 'How do I manage notifications?',
          answer:
              'Go to Settings > Notifications to customize how and when you receive reminder notifications. You can enable/disable sounds, set quiet hours, and more.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Pet Profiles',
      icon: Icons.badge_outlined,
      color: Colors.purple,
      bgColor: const Color(0xFFF3E5F5),
      items: const [
        FaqItem(
          question: 'Can I add more than one pet?',
          answer:
              'Yes! Go to the Pets tab and tap "Add Pet" to create additional pet profiles. There\'s no limit to how many pets you can add.',
        ),
        FaqItem(
          question: 'How do I edit pet information?',
          answer:
              'Tap on any pet\'s profile card to view their details, then tap the edit icon to update their information.',
        ),
        FaqItem(
          question: 'Can I add photos to my pet\'s gallery?',
          answer:
              'Yes! Each pet has their own photo gallery. Open a pet\'s profile and tap "Photo Gallery" to add and manage photos.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Account & Security',
      icon: Icons.security,
      color: Colors.teal,
      bgColor: const Color(0xFFE0F2F1),
      items: const [
        FaqItem(
          question: 'How do I change my password?',
          answer:
              'Go to Settings > Privacy & Security > Change Password. You\'ll need to enter your current password and then your new password twice.',
        ),
        FaqItem(
          question: 'Is my data secure?',
          answer:
              'Yes! All your data is encrypted and stored securely. We never share your personal information or pet data with third parties.',
        ),
        FaqItem(
          question: 'How do I delete my account?',
          answer:
              'Account deletion is not available directly in the app. Please contact support via the Help & Feedback page to request account deletion.',
        ),
      ],
    ),
  ];

  List<FaqCategory> get categories => List.unmodifiable(_categories);

  // Keep for backward compatibility
  List<FaqItem> get items =>
      _categories.expand((category) => category.items).toList();
}
