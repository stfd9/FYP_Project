import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/help_faq_view_model.dart';

class HelpFaqView extends StatelessWidget {
  const HelpFaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HelpFaqViewModel(),
      child: const _HelpFaqBody(),
    );
  }
}

class _HelpFaqBody extends StatelessWidget {
  const _HelpFaqBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HelpFaqViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            return _FaqItem(question: item.question, answer: item.answer);
          },
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      title: Text(
        question,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
