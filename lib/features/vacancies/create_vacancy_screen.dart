import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/vacancy.dart';
import '../auth/auth_provider.dart';
import 'vacancies_provider.dart';

class CreateVacancyScreen extends ConsumerStatefulWidget {
  const CreateVacancyScreen({super.key});
  @override
  ConsumerState<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends ConsumerState<CreateVacancyScreen> {
  final _title = TextEditingController();
  final _ship = TextEditingController();
  final _salary = TextEditingController();
  final _contract = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _title.dispose(); _ship.dispose(); _salary.dispose(); _contract.dispose(); _desc.dispose();
    super.dispose();
  }

  void _save() {
    final user = ref.read(authProvider).user;
    if (user == null || _title.text.isEmpty || _salary.text.isEmpty) return;

    ref.read(vacanciesProvider.notifier).add(Vacancy(
      id: const Uuid().v4(),
      companyId: user.id,
      companyName: user.companyName ?? user.name,
      title: _title.text.trim(),
      shipType: _ship.text.trim().isEmpty ? 'Любой' : _ship.text.trim(),
      salary: _salary.text.trim(),
      contract: _contract.text.trim().isEmpty ? 'По договорённости' : _contract.text.trim(),
      description: _desc.text.trim(),
      createdAt: DateTime.now(),
    ));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новая вакансия')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Должность *')),
          const SizedBox(height: 16),
          TextField(controller: _ship, decoration: const InputDecoration(labelText: 'Тип судна')),
          const SizedBox(height: 16),
          TextField(controller: _salary, decoration: const InputDecoration(labelText: 'Зарплата *')),
          const SizedBox(height: 16),
          TextField(controller: _contract, decoration: const InputDecoration(labelText: 'Контракт')),
          const SizedBox(height: 16),
          TextField(controller: _desc, maxLines: 4, decoration: const InputDecoration(labelText: 'Описание')),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _save, child: const Text('Опубликовать')),
        ]),
      ),
    );
  }
}
