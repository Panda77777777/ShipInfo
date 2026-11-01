import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'reviews_provider.dart';

class ReviewsListScreen extends ConsumerWidget {
  const ReviewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Отзывы')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reviews.length,
        itemBuilder: (_, i) {
          final r = reviews[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(r.companyName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))),
                  ...List.generate(5, (j) => Icon(j < r.rating ? Icons.star : Icons.star_border, size: 16, color: Colors.amber)),
                ]),
                const SizedBox(height: 4),
                Text(r.sailorName, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 8),
                Text(r.text),
                const SizedBox(height: 6),
                Text(DateFormat('dd.MM.yyyy').format(r.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
