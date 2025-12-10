import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/pet_detail_view_model.dart';
import '../models/pet_info.dart';

class PetDetailView extends StatelessWidget {
  const PetDetailView({super.key, required this.pet});

  final PetInfo pet;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetDetailViewModel(pet),
      child: const _PetDetailBody(),
    );
  }
}

class _PetDetailBody extends StatelessWidget {
  const _PetDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetDetailViewModel>();
    final pet = viewModel.pet;

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(
                      viewModel.isDog ? Icons.pets : Icons.pets_outlined,
                      size: 36,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.species} • ${pet.breed}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pet.age,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Basic information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: const [
                    _InfoRow(label: 'Name', fieldSelector: _FieldSelector.name),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'Species',
                      fieldSelector: _FieldSelector.species,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'Breed',
                      fieldSelector: _FieldSelector.breed,
                    ),
                    Divider(height: 1),
                    _InfoRow(label: 'Age', fieldSelector: _FieldSelector.age),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Health overview',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _HealthRow(label: 'Last scan', value: '3 days ago'),
                    SizedBox(height: 6),
                    _HealthRow(
                      label: 'Scan status',
                      value: 'No major issues detected',
                    ),
                    SizedBox(height: 6),
                    _HealthRow(
                      label: 'Next vaccination',
                      value: '20 March 2026',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'You can use this section to store any important details about ${pet.name}, '
                  'such as allergies, favorite food, or special care instructions.',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Remove pet',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => viewModel.confirmRemoval(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _FieldSelector { name, species, breed, age }

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.fieldSelector});

  final String label;
  final _FieldSelector fieldSelector;

  String _resolveValue(PetInfo pet) {
    switch (fieldSelector) {
      case _FieldSelector.name:
        return pet.name;
      case _FieldSelector.species:
        return pet.species;
      case _FieldSelector.breed:
        return pet.breed;
      case _FieldSelector.age:
        return pet.age;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.read<PetDetailViewModel>().pet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _resolveValue(pet),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
