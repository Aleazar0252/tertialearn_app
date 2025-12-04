import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dictionary_flyout.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, String>> history;
  final ScrollController? scrollController;

  const HistoryList({super.key, required this.history, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TRANSLATION HISTORY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
              Icon(Icons.history, size: 16, color: AppTheme.accent.withOpacity(0.5))
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: history.length,
            separatorBuilder: (ctx, i) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(item["word"]!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                trailing: Text(item["time"]!, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                onTap: () {
                   showDialog(context: context, builder: (ctx) => DictionaryFlyout(word: item["word"]!));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}