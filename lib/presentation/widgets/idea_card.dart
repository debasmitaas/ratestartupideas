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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.white.withOpacity(0.15) : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showRank) ...[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    idea.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
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
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: borderColor,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Icon(Icons.psychology,  size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'AI Rating: ${idea.aiRating}/10',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          // color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    idea.aiFeedback,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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
                    Text(
                      '${idea.votes} Votes',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    context.read<IdeaProvider>().toggleVote(idea.id);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_upward, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Upvote',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
