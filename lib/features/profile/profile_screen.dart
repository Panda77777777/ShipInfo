import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const CircleAvatar(radius: 48, backgroundColor: Color(0xFF0D47A1), child: Icon(Icons.person, size: 48, color: Colors.white)),
        const SizedBox(height: 16),
        Center(child: Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        Center(child: Text(user.isSailor ? 'Моряк' : 'Крюинговая компания', style: TextStyle(color: Colors.grey.shade600))),
        const SizedBox(height: 32),
        _row('Email', user.email),
        if (user.companyName != null) _row('Компания', user.companyName!),
        if (user.ranks.isNotEmpty) _row('Должности', user.ranks.join(', ')),
      ]),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      SizedBox(width: 110, child: Text(label, style: TextStyle(color: Colors.grey.shade600))),
      Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
    ]),
  );
}
