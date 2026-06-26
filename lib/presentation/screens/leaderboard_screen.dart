import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/idea_provider.dart';
import '../widgets/idea_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IdeaProvider>(
      builder: (context, provider, child) {
        final topIdeas = provider.topIdeas;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              color: Theme.of(context).primaryColor.withAlpha(25),
              child: Column(
                children: [
                  Icon(Icons.leaderboard_rounded, size: 60, color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,),
                  const SizedBox(height: 8),
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black,
                    ),
                  ),
                  const Text('Top 5 Most Voted Ideas 🔥'),
                ],
              ),
            ),
            Expanded(
              child: topIdeas.isEmpty
                  ? const Center(child: Text('No ideas to rank yet!'))
                  : ListView.builder(
                      itemCount: topIdeas.length,
                      itemBuilder: (context, index) {
                        return IdeaCard(
                          idea: topIdeas[index],
                          showRank: true,
                          rank: index + 1,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
