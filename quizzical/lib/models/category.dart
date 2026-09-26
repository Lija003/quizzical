class TriviaCategory {
  final int id;
  final String name;

  TriviaCategory({
    required this.id,
    required this.name,
  });

  factory TriviaCategory.fromJson(Map<String, dynamic> json) {
    return TriviaCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriviaCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TriviaCategory(id: $id, name: $name)';
}
