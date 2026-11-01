enum UserRole { sailor, crewing }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;
  final String? companyName;
  final List<String> ranks;
  final String? about;
  final double rating;
  final int reviewsCount;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.companyName,
    this.ranks = const [],
    this.about,
    this.rating = 0,
    this.reviewsCount = 0,
  });

  bool get isSailor => role == UserRole.sailor;
  bool get isCrewing => role == UserRole.crewing;
}
