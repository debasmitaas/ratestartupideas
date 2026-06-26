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
            SnackBar(
              content: Text('Failed to get feedback. Please check API connection.'),
              backgroundColor: Colors.deepPurple.shade100,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.white.withOpacity(0.15) : Colors.black;

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
            InkWell(
              onTap: _isSubmitting ? null : _submit,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isSubmitting ? Colors.grey : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 2.5,
                  ),
                  boxShadow: _isSubmitting
                      ? null
                      : [
                          BoxShadow(
                            color: shadowColor,
                            offset: const Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                ),
                alignment: Alignment.center,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Get AI Feedback & Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (_resultFeedback != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Rating: $_resultRating/10',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _resultFeedback!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
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
