import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/dictionary_flyout.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // 1. Filter the list based on search query
    final filteredList = kDictionaryData.where((item) {
      final word = item["word"]!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return word.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text("ASL Dictionary", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 2. SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for a sign...",
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: AppTheme.accent),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),

          // 3. DICTIONARY LIST
          Expanded(
            child: filteredList.isEmpty 
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return _buildDictionaryItem(context, item);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDictionaryItem(BuildContext context, Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
               image: NetworkImage(item["img"]!),
               fit: BoxFit.cover,
               // Fallback for network error
               onError: (e, s) {},
            ),
          ),
          child: item["img"] == null ? const Icon(Icons.image_not_supported) : null,
        ),
        title: Text(
          item["word"]!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        subtitle: Text(
          item["category"] ?? "General",
          style: const TextStyle(color: AppTheme.accent, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
        onTap: () {
          // Open the Flyout we created earlier
          showDialog(
            context: context, 
            builder: (ctx) => DictionaryFlyout(word: item["word"]!)
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text("No words found", style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}