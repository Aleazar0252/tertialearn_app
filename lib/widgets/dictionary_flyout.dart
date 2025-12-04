// lib/widgets/dictionary_flyout.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart'; // Import data

class DictionaryFlyout extends StatelessWidget {
  final String word;
  
  const DictionaryFlyout({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    // Find the word in the dictionary data, or provide a fallback
    final entry = kDictionaryData.firstWhere(
      (e) => e["word"] == word,
      orElse: () => {
        "word": word, 
        "def": "Definition not found in mock data.", 
        "img": "https://via.placeholder.com/150",
        "category": "Unknown"
      },
    );

    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry["word"]!, 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close, color: Colors.white54),
                )
              ],
            ),
            
            // Category Chip
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
              child: Text(
                entry["category"] ?? "General", 
                style: const TextStyle(color: AppTheme.accent, fontSize: 10, fontWeight: FontWeight.bold)
              ),
            ),

            // Definition
            Text(entry["def"]!, style: const TextStyle(color: Colors.white70, height: 1.4)),
            const SizedBox(height: 20),

            // Image Area
            AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black38,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    entry["img"]!, 
                    fit: BoxFit.cover,
                    errorBuilder: (c,e,s) => const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent, 
                  foregroundColor: Colors.black
                ),
                child: const Text("Close"),
              ),
            )
          ],
        ),
      ),
    );
  }
}