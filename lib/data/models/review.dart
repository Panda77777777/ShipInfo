class Review {
  final String id;
  final String companyId;
  final String companyName;
  final String sailorId;
  final String sailorName;
  final int rating;
  final String text;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.sailorId,
    required this.sailorName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });
}
