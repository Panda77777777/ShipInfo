import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../reviews/reviews_provider.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);
    final Map<String, List> byCompany = {};
    for (final r in reviews) {
      byCompany.putIfAbsent(r.companyName, () => []).add(r);
    }
    byCompany.putIfAbsent('Ocean Crew Ltd', () => []);
    byCompany.putIfAbsent('Baltic Manning', () => []);
    byCompany.putIfAbsent('SeaStaff International', () => []);

    final names = byCompany.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Крюинги')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: names.length,
        itemBuilder: (_, i) {
          final name = names[i];
          final list = byCompany[name]!;
          double avg = list.isEmpty ? 0 : list.map((r) => r.rating as int).reduce((a, b) => a + b) / list.length;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(backgroundColor: const Color(0xFF0D47A1), child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Row(children: [
                ...List.generate(5, (j) => Icon(j < avg.round() ? Icons.star : Icons.star_border, size: 18, color: Colors.amber)),
                const SizedBox(width: 8),
                Text(list.isEmpty ? 'Нет отзывов' : '\( {avg.toStringAsFixed(1)} ( \){list.length})', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
