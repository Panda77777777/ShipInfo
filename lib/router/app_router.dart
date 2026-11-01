import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/vacancies/vacancies_screen.dart';
import '../features/vacancies/create_vacancy_screen.dart';
import '../features/reviews/new_review_screen.dart';
import '../features/reviews/reviews_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/company/companies_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: auth.isLoggedIn ? '/home' : '/login',
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final isAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!loggedIn && !isAuth) return '/login';
      if (loggedIn && isAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/vacancies', builder: (_, __) => const VacanciesScreen()),
      GoRoute(path: '/create-vacancy', builder: (_, __) => const CreateVacancyScreen()),
      GoRoute(path: '/reviews/new', builder: (_, __) => const NewReviewScreen()),
      GoRoute(path: '/companies', builder: (_, __) => const CompaniesScreen()),
      GoRoute(path: '/my-reviews', builder: (_, __) => const ReviewsListScreen()),
    ],
  );
});
