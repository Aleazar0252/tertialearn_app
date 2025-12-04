import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart'; // Make sure this import is correct!
import '../data/enums.dart';
import '../widgets/history_list.dart';
import '../widgets/translator_view.dart';
import 'dictionary_screen.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  bool _isCameraActive = false;
  TranslationMode _currentMode = TranslationMode.signToText;
  
  final String _currentTranslation = "HELLO";
  final String _detectedLanguage = "ASL";

  void _toggleCamera() {
    setState(() { _isCameraActive = !_isCameraActive; });
  }

  void _switchMode(TranslationMode mode) {
    setState(() {
      _currentMode = mode;
      if (mode != TranslationMode.signToText) _isCameraActive = false;
    });
  }

  void _navigateToDictionary() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryScreen()));
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
        builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: HistoryList(history: kMockHistory, scrollController: scrollController),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.background,
            elevation: 0,
            
            // TITLE ROW (Logo + Desktop Mode Selector)
            title: Row(
              children: [
                if (isDesktop) ...[
                  const Text("TertiaLearn", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 40),
                ],
                if (isDesktop) _buildModeSelector(isMobile: false),
                if (!isDesktop) const Text("TertiaLearn", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            
            // BOTTOM (Mobile Mode Selector)
            bottom: !isDesktop 
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildModeSelector(isMobile: true),
                  ),
                )
              : null,

            actions: [
              if (!isDesktop) IconButton(onPressed: _showHistorySheet, icon: const Icon(Icons.history)),
              if (isDesktop) ...[
                TextButton.icon(
                  onPressed: _navigateToDictionary, 
                  icon: const Icon(Icons.book, size: 18),
                  label: const Text("DICTIONARY"),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
                const SizedBox(width: 16),
              ]
            ],
          ),
          
          drawer: !isDesktop ? _buildMobileDrawer() : null,

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isDesktop
                ? _buildDesktopLayout()
                : _buildMobileLayout(),
          ),
        );
      },
    );
  }

  // --- LAYOUTS ---

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT: MAIN VIEW
        Expanded(
          flex: 7,
          child: MainTranslatorView(
            isCameraActive: _isCameraActive,
            currentTranslation: _currentTranslation,
            detectedLanguage: _detectedLanguage,
            onToggleCamera: _toggleCamera,
            isMobile: false,
            currentMode: _currentMode,
          ),
        ),
        const SizedBox(width: 16),
        
        // RIGHT: SIDEBAR (Explicitly passing kMockHistory)
        Expanded(
          flex: 3,
          child: Container(
             decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
             child: HistoryList(history: kMockHistory), // <--- CHECK THIS LINE
          ),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: MainTranslatorView(
            isCameraActive: _isCameraActive,
            currentTranslation: _currentTranslation,
            detectedLanguage: _detectedLanguage,
            onToggleCamera: _toggleCamera,
            isMobile: true,
            currentMode: _currentMode,
          ),
        ),
      ],
    );
  }

  // --- COMPONENTS ---

  Widget _buildModeSelector({required bool isMobile}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ToggleButtons(
        isSelected: [
          _currentMode == TranslationMode.signToText,
          _currentMode == TranslationMode.textToSign,
          _currentMode == TranslationMode.speechToSign,
        ],
        onPressed: (index) {
          if (index == 0) _switchMode(TranslationMode.signToText);
          if (index == 1) _switchMode(TranslationMode.textToSign);
          if (index == 2) _switchMode(TranslationMode.speechToSign);
        },
        borderRadius: BorderRadius.circular(20),
        selectedColor: Colors.black,
        fillColor: AppTheme.accent,
        color: Colors.white54,
        renderBorder: false,
        constraints: BoxConstraints(minWidth: isMobile ? 60 : 100, minHeight: 40),
        children: [
          _buildToggleItem(Icons.camera_alt, "Sign", isMobile),
          _buildToggleItem(Icons.keyboard, "Text", isMobile),
          _buildToggleItem(Icons.mic, "Speech", isMobile),
        ],
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String label, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18),
        if (!isMobile) ...[const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))],
      ],
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: AppTheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppTheme.background),
            accountName: Text("Student Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            accountEmail: Text("student@wmsu.edu.ph", style: TextStyle(color: Colors.white70)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppTheme.accent,
              child: Icon(Icons.person, color: Colors.black, size: 36),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book, color: AppTheme.accent),
            title: const Text("Dictionary", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _navigateToDictionary();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text("Settings", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}