class Vacancy {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String shipType;
  final String salary;
  final String contract;
  final String description;
  final DateTime createdAt;
  final bool isActive;

  const Vacancy({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.shipType,
    required this.salary,
    required this.contract,
    required this.description,
    required this.createdAt,
    this.isActive = true,
  });
}
