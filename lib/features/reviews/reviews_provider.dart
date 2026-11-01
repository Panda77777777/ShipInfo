import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/review.dart';

class ReviewsNotifier extends StateNotifier<List<Review>> {
  ReviewsNotifier() : super([
    Review(id: 'r1', companyId: 'c1', companyName: 'Ocean Crew Ltd', sailorId: 's1',
      sailorName: 'Алексей К.', rating: 5, text: 'Отличная компания, всё вовремя. Рекомендую.',
      createdAt: DateTime.now().subtract(const Duration(days: 5))),
    Review(id: 'r2', companyId: 'c2', companyName: 'Baltic Manning', sailorId: 's2',
      sailorName: 'Игорь М.', rating: 3, text: 'Зарплату задержали на 2 недели.',
      createdAt: DateTime.now().subtract(const Duration(days: 12))),
  ]);

  void add(Review r) => state = [r, ...state];
}

final reviewsProvider = StateNotifierProvider<ReviewsNotifier, List<Review>>((ref) => ReviewsNotifier());
