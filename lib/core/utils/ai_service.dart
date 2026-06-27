import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static Future<Map<String, dynamic>> generateFeedback(String description) async {
    if (description.trim().isEmpty) {
      return {
        'rating': 1,
        'feedback': 'Please provide more details about your idea.',
      };
    }

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      const prompt = '''
You are an expert startup evaluator and venture capitalist.
Evaluate the following startup idea and respond with a strict JSON object containing exactly two keys:
- "rating": an integer from 1 to 10.
- "feedback": 1–2 concise sentences summarising your evaluation.

Return only valid JSON — no markdown, no extra text.

Idea: "''';

      final response = await model.generateContent(
        [Content.text('$prompt$description"')],
      );

      final raw = response.text ?? '';
      final cleaned = raw
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;

      return {
        'rating': (parsed['rating'] as num?)?.toInt() ?? 5,
        'feedback': parsed['feedback']?.toString() ?? 'No feedback available.',
      };
    } catch (e) {
      return {
        'rating': null,
        'feedback': 'Failed to evaluate',
      };
    }
  }
}
