import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../../data/models/user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('FleetWatch'),
        actions: [IconButton(icon: const Icon(Icons.person), onPressed: () => context.push('/profile'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF0D47A1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Привет, ${user.name}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                Text(user.isSailor ? (user.ranks.isEmpty ? 'Моряк' : user.ranks.join(', ')) : (user.companyName ?? 'Крюинг'),
                  style: const TextStyle(color: Colors.white70)),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          if (user.isSailor) ...[
            _card(Icons.work_outline, 'Вакансии', 'Найти работу', () => context.push('/vacancies')),
            _card(Icons.business, 'Крюинги', 'Рейтинги и отзывы', () => context.push('/companies')),
            _card(Icons.rate_review, 'Оставить отзыв', 'Оценить крюинг', () => context.push('/reviews/new')),
          ],
          if (user.isCrewing) ...[
            _card(Icons.add_box_outlined, 'Создать вакансию', 'Опубликовать новую', () => context.push('/create-vacancy')),
            _card(Icons.work_outline, 'Мои вакансии', 'Управление', () => context.push('/vacancies')),
            _card(Icons.star_outline, 'Отзывы', 'Что пишут моряки', () => context.push('/my-reviews')),
          ],
          const SizedBox(height: 12),
          _card(Icons.logout, 'Выйти', user.email, () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          }),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String title, String sub, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: const Color(0xFF0D47A1).withOpacity(0.1), child: Icon(icon, color: const Color(0xFF0D47A1))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
