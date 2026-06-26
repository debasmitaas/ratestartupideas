import 'package:flutter/material.dart';
import '../../domain/entities/idea.dart';
import 'package:provider/provider.dart';
import '../providers/idea_provider.dart';
import 'package:share_plus/share_plus.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  final bool showRank;
  final int rank;

  const IdeaCard({
    Key? key,
    required this.idea,
    this.showRank = false,
    this.rank = 0,
  }) : super(key: key);

  void _shareIdea() {
    Share.share('Check out this startup idea: ${idea.title}!\n\n${idea.description}\n\nAI Rating: ${idea.aiRating}/10');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showRank) ...[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      '#$rank',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    idea.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: _shareIdea,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              idea.description,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.blueAccent, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'AI Rating: ${idea.aiRating}/10',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    idea.aiFeedback,
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('${idea.votes} Votes', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<IdeaProvider>().toggleVote(idea.id);
                  },
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: const Text('Upvote'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
