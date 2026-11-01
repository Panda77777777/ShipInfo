import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/ranks.dart';
import '../../data/models/user.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _company = TextEditingController();
  UserRole _role = UserRole.sailor;
  final Set<String> _selectedRanks = {};
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _company.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _error = null);
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty || _password.text.length < 6) {
      setState(() => _error = 'Заполните все поля (пароль минимум 6 символов)');
      return;
    }
    if (_role == UserRole.crewing && _company.text.trim().isEmpty) {
      setState(() => _error = 'Укажите название компании');
      return;
    }

    final err = await ref.read(authProvider.notifier).register(
      email: _email.text.trim(),
      password: _password.text,
      name: _name.text.trim(),
      role: _role,
      companyName: _role == UserRole.crewing ? _company.text.trim() : null,
      ranks: _selectedRanks.toList(),
    );

    if (err != null) {
      setState(() => _error = err);
    } else if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Кто вы?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ChoiceChip(label: const Text('Моряк'), selected: _role == UserRole.sailor,
                onSelected: (_) => setState(() => _role = UserRole.sailor))),
              const SizedBox(width: 12),
              Expanded(child: ChoiceChip(label: const Text('Крюинг'), selected: _role == UserRole.crewing,
                onSelected: (_) => setState(() => _role = UserRole.crewing))),
            ]),
            const SizedBox(height: 24),
            TextField(controller: _name, decoration: InputDecoration(
              labelText: _role == UserRole.sailor ? 'Ваше имя' : 'Контактное лицо',
              prefixIcon: const Icon(Icons.person_outline))),
            if (_role == UserRole.crewing) ...[
              const SizedBox(height: 16),
              TextField(controller: _company, decoration: const InputDecoration(
                labelText: 'Название компании', prefixIcon: Icon(Icons.business))),
            ],
            const SizedBox(height: 16),
            TextField(controller: _email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 16),
            TextField(controller: _password, obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль', prefixIcon: Icon(Icons.lock_outlined))),
            if (_role == UserRole.sailor) ...[
              const SizedBox(height: 24),
              const Text('Ваши должности', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: sailorRanks.map((rank) {
                final selected = _selectedRanks.contains(rank);
                return FilterChip(label: Text(rank), selected: selected, onSelected: (v) {
                  setState(() { if (v) _selectedRanks.add(rank); else _selectedRanks.remove(rank); });
                });
              }).toList()),
            ],
            if (_error != null) ...[const SizedBox(height: 16), Text(_error!, style: const TextStyle(color: Colors.red))],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child: isLoading
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
