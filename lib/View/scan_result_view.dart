import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scan_type.dart';
import '../ViewModel/scan_result_view_model.dart';

class ScanResultView extends StatelessWidget {
  const ScanResultView({
    super.key,
    required this.scanType,
    required this.imageFile,
  });

  final ScanType scanType;
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ScanResultViewModel(scanType: scanType, imageFile: imageFile),
      child: const _ScanResultBody(),
    );
  }
}

class _ScanResultBody extends StatelessWidget {
  const _ScanResultBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<ScanResultViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Scan result'), centerTitle: true),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(viewModel.imageFile, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Text(
                'Analysis results',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: viewModel.predictions.map((prediction) {
                    final percent = (prediction.confidence * 100)
                        .toStringAsFixed(1);
                    return ListTile(
                      title: Text(
                        prediction.label,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        '$percent%',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.detailsTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  viewModel.advisoryText,
                  style: textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.warningText,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
