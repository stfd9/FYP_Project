import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/scan_history_view_model.dart';

class ScanHistoryView extends StatelessWidget {
  const ScanHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanHistoryViewModel(),
      child: const _ScanHistoryBody(),
    );
  }
}

class _ScanHistoryBody extends StatelessWidget {
  const _ScanHistoryBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScanHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan history'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: viewModel.hasHistory
              ? ListView.separated(
                  itemCount: viewModel.history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = viewModel.history[index];
                    return _HistoryCard(
                      item: item,
                      onTap: () => viewModel.openHistoryItem(context, item),
                    );
                  },
                )
              : const _EmptyHistoryView(),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onTap});

  final ScanHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = item.isDisease
        ? Icons.coronavirus_outlined
        : Icons.pets_outlined;
    final String typeLabel = item.isDisease ? 'Skin disease' : 'Breed';
    final String subtitle =
        '$typeLabel · ${item.topLabel} · ${(item.confidence * 100).toStringAsFixed(1)}%';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.dateLabel,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: const Icon(Icons.history, size: 32, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'No scans yet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Your scan history will appear here after you analyse\n'
            'your pet’s skin or breed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
