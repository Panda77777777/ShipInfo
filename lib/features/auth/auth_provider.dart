import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  const AuthState({this.user, this.isLoading = false});
  bool get isLoggedIn => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  static final Map<String, User> _users = {};
  static final Map<String, String> _passwords = {};

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? companyName,
    List<String> ranks = const [],
  }) async {
    state = const AuthState(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_users.values.any((u) => u.email == email)) {
      state = const AuthState();
      return 'Этот email уже зарегистрирован';
    }

    final user = User(
      id: const Uuid().v4(),
      email: email,
      name: name,
      role: role,
      companyName: companyName,
      ranks: ranks,
    );

    _users[user.id] = user;
    _passwords[email] = password;
    state = AuthState(user: user);
    return null;
  }

  Future<String?> login(String email, String password) async {
    state = const AuthState(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _users.values.cast<User?>().firstWhere(
      (u) => u?.email == email, orElse: () => null);

    if (user == null || _passwords[email] != password) {
      state = const AuthState();
      return 'Неверный email или пароль';
    }

    state = AuthState(user: user);
    return null;
  }

  void logout() => state = const AuthState();
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
