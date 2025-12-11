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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Manage FAQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: const Color(0xFF2D3142),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFAQDialog(context, viewModel, null),
        label: const Text(
          'Add FAQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Browse by Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // --- ITERATE THROUGH DEFINED CATEGORIES ---
          ...viewModel.categoryDefinitions.map((categoryDef) {
            // Get items belonging to this category
            final items = viewModel.getFaqsByCategory(categoryDef.title);

            return _CategoryCard(
              categoryDef: categoryDef,
              items: items,
              viewModel: viewModel,
              onEditItem: (faq) => _showFAQDialog(context, viewModel, faq),
            );
          }),
        ],
      ),
    );
  }

  // --- Dialog Logic ---
  void _showFAQDialog(
    BuildContext context,
    ManageFAQViewModel viewModel,
    AdminFaqItem? faq,
  ) {
    final isEditing = faq != null;
    final questionController = TextEditingController(
      text: isEditing ? faq.question : '',
    );
    final answerController = TextEditingController(
      text: isEditing ? faq.answer : '',
    );

    // Default to the first category if creating new
    String selectedCategory = isEditing
        ? faq.categoryTitle
        : viewModel.categoryDefinitions.first.title;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              isEditing ? 'Edit FAQ' : 'New FAQ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        // Create items from the Category Definitions
                        items: viewModel.categoryDefinitions.map((def) {
                          return DropdownMenuItem<String>(
                            value: def.title,
                            child: Text(def.title),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null)
                            setState(() => selectedCategory = newValue);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: 'Answer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (questionController.text.isNotEmpty &&
                      answerController.text.isNotEmpty) {
                    if (isEditing) {
                      viewModel.editFAQ(
                        faq.id,
                        questionController.text,
                        answerController.text,
                        selectedCategory,
                      );
                    } else {
                      viewModel.addFAQ(
                        questionController.text,
                        answerController.text,
                        selectedCategory,
                      );
                    }
                    Navigator.pop(ctx);
                  }
                },
                child: Text(isEditing ? 'Save' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- Category Card Widget ---
class _CategoryCard extends StatefulWidget {
  final FaqCategoryDef categoryDef;
  final List<AdminFaqItem> items;
  final ManageFAQViewModel viewModel;
  final Function(AdminFaqItem) onEditItem;

  const _CategoryCard({
    required this.categoryDef,
    required this.items,
    required this.viewModel,
    required this.onEditItem,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Visuals from Definition
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.categoryDef.bgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        widget.categoryDef.icon,
                        color: widget.categoryDef.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categoryDef.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.items.length} questions',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade100),
                if (widget.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No questions in this category yet.',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ...widget.items.map(
                  (faq) => _AdminFaqItemTile(
                    faq: faq,
                    viewModel: widget.viewModel,
                    onEdit: () => widget.onEditItem(faq),
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// --- Item Tile ---
class _AdminFaqItemTile extends StatelessWidget {
  final AdminFaqItem faq;
  final ManageFAQViewModel viewModel;
  final VoidCallback onEdit;

  const _AdminFaqItemTile({
    required this.faq,
    required this.viewModel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade50, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          faq.question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            faq.answer,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 18, color: Colors.blue.shade300),
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade300,
              ),
              onPressed: () => _confirmDelete(context),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete FAQ'),
        content: const Text('Remove this question permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              viewModel.deleteFAQ(context, faq.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
