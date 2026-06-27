import 'package:flutter/material.dart';
import '../../domain/entities/idea.dart';
import '../../domain/repositories/idea_repository.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/ai_service.dart';

enum SortOption { rating, votes }

class IdeaProvider extends ChangeNotifier {
  final IdeaRepository repository;
  
  List<Idea> _ideas = [];
  bool _isLoading = false;
  SortOption _currentSort = SortOption.rating;

  IdeaProvider({required this.repository}) {
    loadIdeas();
  }

  List<Idea> get ideas => [..._ideas]..sort((a, b) {
    if (_currentSort == SortOption.rating) {
      return (b.aiRating ?? 0).compareTo(a.aiRating ?? 0);
    } else {
      return b.votes.compareTo(a.votes);
    }
  });

  List<Idea> get topIdeas => [..._ideas]..sort((a, b) => b.votes.compareTo(a.votes))..take(5).toList();
  
  bool get isLoading => _isLoading;
  SortOption get currentSort => _currentSort;

  void setSortOption(SortOption option) {
    _currentSort = option;
    notifyListeners();
  }

  Future<void> loadIdeas() async {
    _isLoading = true;
    notifyListeners();
    
    _ideas = await repository.getIdeas();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Idea?> addIdea(String title, String description) async {
    try {
      final aiInfo = await AIService.generateFeedback(description);
      
      final idea = Idea(
        id: const Uuid().v4(),
        title: title,
        description: description,
        aiRating: aiInfo['rating'],
        aiFeedback: aiInfo['feedback'],
        createdAt: DateTime.now(),
      );

      await repository.saveIdea(idea);
      _ideas.add(idea);
      notifyListeners();
      return idea;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> toggleVote(String id) async {
    final index = _ideas.indexWhere((idea) => idea.id == id);
    if (index != -1) {
      final idea = _ideas[index];
      // For simplicity, we just increment vote
      final updatedIdea = idea.copyWith(votes: idea.votes + 1);
      _ideas[index] = updatedIdea;
      await repository.updateIdea(updatedIdea);
      notifyListeners();
    }
  }
}
