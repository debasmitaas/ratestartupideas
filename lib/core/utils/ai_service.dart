import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static Future<Map<String, dynamic>> generateFeedback(String description) async {
    print('\n--- 🚀 AIService API triggered ---');
    print('Input Idea: $description');

    if (description.trim().isEmpty) {
      return {
        'rating': 1,
        'feedback': "Please provide more details."
      };
    }

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      final safeKey = (apiKey != null && apiKey.isNotEmpty) 
          ? apiKey.substring(0, min(5, apiKey.length)) + "..." 
          : "NONE or NULL";
      print('🔑 API Key detected: $safeKey');

      if (apiKey == null || apiKey.isEmpty || apiKey == 'gibberish_api_key_replace_with_real_one') {
        print('⚠️ Using fallback feedback because API key is invalid/gibberish.');
        return _fallbackFeedback(description);
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
You are an expert startup evaluator and AI assistant.
Evaluate the following startup idea and provide a strict JSON response. 
The response MUST contain only a valid JSON object with exactly two keys:
- "rating": an integer between 1 and 10.
- "feedback": a short string (1 or 2 sentences) summarizing your evaluation.

Idea: "$description"
''';

      print('⏳ Sending request to Gemini Server...');
      final response = await model.generateContent([Content.text(prompt)]);
      print('✅ Raw response coming from Gemini: ${response.text}');

      final text = response.text ?? '';
      
      // Clean up markdown block if present
      final cleanedText = text.replaceFirst('```json', '').replaceFirst('```', '').trim();
      print('🧹 Cleaned Text before parsing: $cleanedText');
      
      final parsed = jsonDecode(cleanedText);

      return {
        'rating': (parsed['rating'] as num?)?.toInt() ?? 5,
        'feedback': parsed['feedback']?.toString() ?? "Could not generate feedback.",
      };
    } catch (e) {
      print('❌ ERROR generating feedback from API: $e');
      // In case of error (e.g. no internet, wrong key), use fallback
      return _fallbackFeedback(description);
    }
  }

  static Map<String, dynamic> _fallbackFeedback(String description) {
    final random = Random();
    int scoreBase = description.length > 50 ? 5 : 2;
    int rating = scoreBase + random.nextInt(6); 
    if (rating > 10) rating = 10;

    return {
      'rating': rating,
      'feedback': "Great idea! (Disclaimer: This is fallback feedback because the API key is not set or failed.)",
    };
  }
}
