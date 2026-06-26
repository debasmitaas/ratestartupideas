import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/idea_provider.dart';
import '../widgets/custom_text_field.dart';

class IdeaSubmissionScreen extends StatefulWidget {
  const IdeaSubmissionScreen({super.key});

  @override
  State<IdeaSubmissionScreen> createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  String? _resultFeedback;
  int? _resultRating;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _resultFeedback = null;
        _resultRating = null;
      });

      final provider = context.read<IdeaProvider>();
      final idea = await provider.addIdea(
        _titleController.text,
        _descriptionController.text,
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (idea != null) {
          setState(() {
             _resultFeedback = idea.aiFeedback;
             _resultRating = idea.aiRating;
          });
          _titleController.clear();
          _descriptionController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get feedback. Please check API connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Submit Your Startup Idea ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'Cool Startup Idea',
              validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe what problem it solves...',
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting 
                  ? const CircularProgressIndicator()
                  : const Text('Get AI Feedback & Submit', style: TextStyle(fontSize: 16)),
            ),
            if (_resultFeedback != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Rating: $_resultRating/10',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _resultFeedback!,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
