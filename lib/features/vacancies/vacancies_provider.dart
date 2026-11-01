import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/vacancy.dart';

class VacanciesNotifier extends StateNotifier<List<Vacancy>> {
  VacanciesNotifier() : super([
    Vacancy(id: '1', companyId: 'c1', companyName: 'Ocean Crew Ltd', title: 'Старший помощник',
      shipType: 'Bulk Carrier', salary: '\$4500–5000', contract: '6+1 месяц',
      description: 'Требуется Senior Officer с опытом на балкерах.', createdAt: DateTime.now().subtract(const Duration(days: 1))),
    Vacancy(id: '2', companyId: 'c2', companyName: 'Baltic Manning', title: 'Матрос (AB)',
      shipType: 'Container', salary: '\$1800–2100', contract: '4+2 месяца',
      description: 'Опыт от 12 месяцев. STCW обязателен.', createdAt: DateTime.now().subtract(const Duration(days: 3))),
  ]);

  void add(Vacancy v) => state = [v, ...state];
}

final vacanciesProvider = StateNotifierProvider<VacanciesNotifier, List<Vacancy>>((ref) => VacanciesNotifier());
