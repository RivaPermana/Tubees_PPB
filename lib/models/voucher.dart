class Voucher {
  final int id;
  final String name;
  final int points;
  final String image;
  final String description;

  Voucher({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    required this.description,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      name: json['name'],
      points: json['points'],
      image: json['image'],
      description: json['description'],
    );
  }
}
