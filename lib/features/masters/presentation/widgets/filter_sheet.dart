import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/master_enums.dart';
import '../providers/master_providers.dart';

Future<void> showMasterFilterSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _FilterSheet(),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late MasterFilters _draft = ref.read(masterFiltersProvider);

  @override
  Widget build(BuildContext context) {
    final reference = ref.watch(academicReferenceDataProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: context.textStyles.titleLarge),
                  TextButton(
                    onPressed: () => setState(() => _draft = const MasterFilters()),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Status', style: context.textStyles.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: MasterListingStatus.values.map((status) {
                  final label = switch (status) {
                    MasterListingStatus.open => 'Open',
                    MasterListingStatus.closingSoon => 'Closing Soon',
                    MasterListingStatus.closed => 'Closed',
                  };
                  return FilterChip(
                    label: Text(label),
                    selected: _draft.status == status,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(
                          status: v ? status : null,
                          clearStatus: !v,
                        )),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Deadline', style: context.textStyles.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('This week'),
                    selected: _draft.deadlineWithinDays == 7,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(
                          deadlineWithinDays: v ? 7 : null,
                          clearDeadline: !v,
                        )),
                  ),
                  FilterChip(
                    label: const Text('This month'),
                    selected: _draft.deadlineWithinDays == 30,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(
                          deadlineWithinDays: v ? 30 : null,
                          clearDeadline: !v,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Specialization', style: context.textStyles.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reference.specializations.map((spec) {
                  return FilterChip(
                    label: Text(spec.label),
                    selected: _draft.specialization == spec.id,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(
                          specialization: v ? spec.id : null,
                          clearSpecialization: !v,
                        )),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('City', style: context.textStyles.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reference.cities.map((city) {
                  return FilterChip(
                    label: Text(city),
                    selected: _draft.city == city,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(
                          city: v ? city : null,
                          clearCity: !v,
                        )),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    ref.read(masterFiltersProvider.notifier).state = _draft;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
