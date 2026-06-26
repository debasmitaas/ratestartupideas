import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/idea_provider.dart';
import '../widgets/idea_card.dart';

class IdeaListScreen extends StatelessWidget {
  const IdeaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IdeaProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final ideas = provider.ideas;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All Ideas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  DropdownButton<SortOption>(
                    value: provider.currentSort,
                    items: const [
                      DropdownMenuItem(value: SortOption.rating, child: Text('Top Rated')),
                      DropdownMenuItem(value: SortOption.votes, child: Text('Most Voted')),
                    ],
                    onChanged: (val) {
                      if (val != null) provider.setSortOption(val);
                    },
                  )
                ],
              ),
            ),
            if (ideas.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No ideas submitted yet.\nBe the first! ', textAlign: TextAlign.center),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: ideas.length,
                  itemBuilder: (context, index) {
                    return IdeaCard(idea: ideas[index]);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
