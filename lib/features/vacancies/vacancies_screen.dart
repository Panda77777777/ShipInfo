import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'vacancies_provider.dart';

class VacanciesScreen extends ConsumerWidget {
  const VacanciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(vacanciesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Вакансии')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final v = list[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                const SizedBox(height: 4),
                Text(v.companyName, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text('${v.shipType}  •  ${v.salary}  •  ${v.contract}'),
                const SizedBox(height: 6),
                Text(v.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(DateFormat('dd.MM.yyyy').format(v.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
