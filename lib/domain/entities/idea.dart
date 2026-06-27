class Idea {
  final String id;
  final String title;
  final String description;
  final int? aiRating; // 1 to 10 (can be null if evaluation failed)
  final String aiFeedback;
  int votes;
  final DateTime createdAt;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    this.aiRating,
    required this.aiFeedback,
    this.votes = 0,
    required this.createdAt,
  });

  Idea copyWith({
    String? id,
    String? title,
    String? description,
    int? aiRating,
    String? aiFeedback,
    int? votes,
    DateTime? createdAt,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      aiRating: aiRating ?? this.aiRating,
      aiFeedback: aiFeedback ?? this.aiFeedback,
      votes: votes ?? this.votes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
