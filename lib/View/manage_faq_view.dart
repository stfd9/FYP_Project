import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/manage_faq_view_model.dart';

class ManageFAQView extends StatelessWidget {
  const ManageFAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageFAQViewModel(),
      child: const _ManageFAQBody(),
    );
  }
}

class _ManageFAQBody extends StatelessWidget {
  const _ManageFAQBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManageFAQViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Manage FAQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFAQDialog(context, viewModel, null),
        label: const Text('Add New FAQ'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: viewModel.faqs.isEmpty
          ? Center(
              child: Text(
                'No FAQs added yet.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.faqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final faq = viewModel.faqs[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              faq.answer,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Edit'),
                                  onPressed: () =>
                                      _showFAQDialog(context, viewModel, faq),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => _confirmDelete(
                                    context,
                                    viewModel,
                                    faq.id,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // --- Helper: Show Dialog for Create/Edit ---
  void _showFAQDialog(
    BuildContext context,
    ManageFAQViewModel viewModel,
    FAQItem? faq,
  ) {
    final isEditing = faq != null;
    final questionController = TextEditingController(
      text: isEditing ? faq.question : '',
    );
    final answerController = TextEditingController(
      text: isEditing ? faq.answer : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit FAQ' : 'New FAQ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'e.g., How to reset password?',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  hintText: 'Enter the detailed answer here...',
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionController.text.isNotEmpty &&
                  answerController.text.isNotEmpty) {
                if (isEditing) {
                  viewModel.editFAQ(
                    faq.id,
                    questionController.text,
                    answerController.text,
                  );
                } else {
                  viewModel.addFAQ(
                    questionController.text,
                    answerController.text,
                  );
                }
                Navigator.pop(ctx);
              }
            },
            child: Text(isEditing ? 'Save Changes' : 'Add FAQ'),
          ),
        ],
      ),
    );
  }

  // --- Helper: Confirm Delete ---
  void _confirmDelete(
    BuildContext context,
    ManageFAQViewModel viewModel,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete FAQ'),
        content: const Text('Are you sure you want to remove this FAQ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              viewModel.deleteFAQ(context, id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
