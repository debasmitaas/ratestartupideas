import '../../domain/entities/idea.dart';

class IdeaModel extends Idea {
  IdeaModel({
    required String id,
    required String title,
    required String description,
    required int aiRating,
    required String aiFeedback,
    int votes = 0,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          aiRating: aiRating,
          aiFeedback: aiFeedback,
          votes: votes,
          createdAt: createdAt,
        );

  factory IdeaModel.fromJson(Map<String, dynamic> json) {
    return IdeaModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      aiRating: json['aiRating'],
      aiFeedback: json['aiFeedback'],
      votes: json['votes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'aiRating': aiRating,
      'aiFeedback': aiFeedback,
      'votes': votes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory IdeaModel.fromEntity(Idea idea) {
    return IdeaModel(
      id: idea.id,
      title: idea.title,
      description: idea.description,
      aiRating: idea.aiRating,
      aiFeedback: idea.aiFeedback,
      votes: idea.votes,
      createdAt: idea.createdAt,
    );
  }
}
