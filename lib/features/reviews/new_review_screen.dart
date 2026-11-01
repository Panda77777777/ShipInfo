import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/review.dart';
import '../auth/auth_provider.dart';
import 'reviews_provider.dart';

class NewReviewScreen extends ConsumerStatefulWidget {
  const NewReviewScreen({super.key});
  @override
  ConsumerState<NewReviewScreen> createState() => _NewReviewScreenState();
}

class _NewReviewScreenState extends ConsumerState<NewReviewScreen> {
  final _company = TextEditingController();
  final _text = TextEditingController();
  int _rating = 5;

  @override
  void dispose() { _company.dispose(); _text.dispose(); super.dispose(); }

  void _submit() {
    final user = ref.read(authProvider).user;
    if (user == null || _company.text.trim().isEmpty || _text.text.trim().isEmpty) return;

    ref.read(reviewsProvider.notifier).add(Review(
      id: const Uuid().v4(), companyId: 'temp', companyName: _company.text.trim(),
      sailorId: user.id, sailorName: user.name, rating: _rating,
      text: _text.text.trim(), createdAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Отзыв отправлен')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый отзыв')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(controller: _company, decoration: const InputDecoration(labelText: 'Название крюинга', prefixIcon: Icon(Icons.business))),
          const SizedBox(height: 24),
          const Text('Оценка', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(children: List.generate(5, (i) => IconButton(
            onPressed: () => setState(() => _rating = i + 1),
            icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 36),
          ))),
          const SizedBox(height: 16),
          TextField(controller: _text, maxLines: 5, decoration: const InputDecoration(labelText: 'Ваш отзыв', alignLabelWithHint: true)),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _submit, child: const Text('Отправить отзыв')),
        ]),
      ),
    );
  }
}
