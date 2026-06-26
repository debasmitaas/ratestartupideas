import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/idea_model.dart';
import '../../domain/entities/idea.dart';
import '../../domain/repositories/idea_repository.dart';

class IdeaRepositoryImpl implements IdeaRepository {
  final SharedPreferences sharedPreferences;
  static const String _storageKey = 'ideas_storage';

  IdeaRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<Idea>> getIdeas() async {
    final String? ideasJson = sharedPreferences.getString(_storageKey);
    if (ideasJson != null) {
      final List<dynamic> decoded = json.decode(ideasJson);
      return decoded.map<Idea>((e) => IdeaModel.fromJson(e)).toList();
    }
    return <Idea>[];
  }

  @override
  Future<void> saveIdea(Idea idea) async {
    final ideas = await getIdeas();
    ideas.add(idea);
    await _saveToPrefs(ideas);
  }

  @override
  Future<void> updateIdea(Idea idea) async {
    final ideas = await getIdeas();
    final index = ideas.indexWhere((e) => e.id == idea.id);
    if (index != -1) {
      ideas[index] = idea;
      await _saveToPrefs(ideas);
    }
  }

  @override
  Future<void> deleteIdea(String id) async {
    final ideas = await getIdeas();
    ideas.removeWhere((idea) => idea.id == id);
    await _saveToPrefs(ideas);
  }

  Future<void> _saveToPrefs(List<Idea> ideas) async {
    final List<Map<String, dynamic>> ideasMap = 
        ideas.map((e) => IdeaModel.fromEntity(e).toJson()).toList();
    await sharedPreferences.setString(_storageKey, json.encode(ideasMap));
  }
}
