import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/enums.dart';

class MainTranslatorView extends StatelessWidget {
  final bool isCameraActive;
  final String currentTranslation;
  final String detectedLanguage;
  final VoidCallback onToggleCamera;
  final bool isMobile;
  final TranslationMode currentMode;

  const MainTranslatorView({
    super.key,
    required this.isCameraActive,
    required this.currentTranslation,
    required this.detectedLanguage,
    required this.onToggleCamera,
    required this.isMobile,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // 1. VISUAL AREA (Result)
        Expanded(
          flex: 5,
          child: _buildVisualArea(),
        ),

        const SizedBox(height: 20),

        // 2. CONTROLS AREA
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(isMobile ? 30 : AppTheme.borderRadius),
          ),
          child: _buildControlArea(),
        ),
      ],
    );
  }

  // --- VISUAL AREA LOGIC ---
  Widget _buildVisualArea() {
    // MODE: SIGN TO TEXT (Camera)
    if (currentMode == TranslationMode.signToText) {
      return Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: isMobile ? Alignment.center : Alignment.centerLeft,
              child: Text(
                currentTranslation,
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: 1.5),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                border: Border.all(color: isCameraActive ? AppTheme.accent : Colors.white10, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: isCameraActive
                    // Use a placeholder image or actual camera package later
                    ? Container(color: Colors.black, child: const Center(child: Text("Camera Feed Active", style: TextStyle(color: Colors.white)))) 
                    : const Center(child: Icon(Icons.videocam_off, size: 64, color: Colors.white24)),
              ),
            ),
          ),
        ],
      );
    } 
    
    // MODE: TEXT/SPEECH (Avatar Output)
    // FIX: Removed Image.network to prevent freezing
    else {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surface, // Use a solid color instead of network image
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(color: Colors.white10, width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Avatar Placeholder
            Icon(Icons.person, size: 120, color: Colors.white.withOpacity(0.1)),
            
            // Play Button Overlay
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.accent.withOpacity(0.8),
              child: const Icon(Icons.play_arrow, color: Colors.black, size: 40),
            ),
            
            const Positioned(
              bottom: 20, 
              child: Text("AI Avatar Ready", style: TextStyle(color: Colors.white54)),
            )
          ],
        ),
      );
    }
  }

  // --- CONTROL AREA LOGIC ---
  Widget _buildControlArea() {
    if (isMobile) {
      return _buildMobileControls();
    } else {
      return _buildDesktopControls();
    }
  }

  Widget _buildMobileControls() {
    // ... (Keep existing Mobile Controls logic)
     IconData mainIcon = Icons.circle; // Default
    Color mainColor = AppTheme.accent;
    VoidCallback mainAction = onToggleCamera;

    switch (currentMode) {
      case TranslationMode.signToText:
        mainIcon = isCameraActive ? Icons.stop : Icons.camera_alt;
        mainColor = isCameraActive ? Colors.redAccent : AppTheme.accent;
        break;
      case TranslationMode.textToSign:
        mainIcon = Icons.translate;
        mainAction = () {}; 
        break;
      case TranslationMode.speechToSign:
        mainIcon = Icons.mic;
        mainAction = () {};
        break;
    }

    return Column(
      children: [
        if (currentMode == TranslationMode.textToSign)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type text to sign...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleBtn(icon: Icons.cached, color: Colors.blueGrey, onPressed: (){}),
            SizedBox(
              width: 70, height: 70,
              child: FloatingActionButton(
                onPressed: mainAction,
                backgroundColor: mainColor,
                elevation: 0,
                shape: const CircleBorder(),
                child: Icon(mainIcon, size: 30, color: Colors.black),
              ),
            ),
            _buildCircleBtn(icon: Icons.volume_up, color: Colors.blueGrey, onPressed: (){}),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopControls() {
    return Row(
      children: [
        Expanded(child: _buildDesktopInputArea()),
        const SizedBox(width: 16),
        _buildDesktopActionButton(),
      ],
    );
  }

  Widget _buildDesktopInputArea() {
    switch (currentMode) {
      case TranslationMode.signToText:
        return Row(
          children: [
            _buildLabelChip("Camera: Webcam", Icons.camera),
            const SizedBox(width: 12),
            _buildLabelChip("Lang: ASL", Icons.language),
          ],
        );
      case TranslationMode.textToSign:
        return TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Type phrase to translate...",
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.keyboard, color: Colors.white54),
          ),
        );
      case TranslationMode.speechToSign:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.graphic_eq, color: AppTheme.accent),
              SizedBox(width: 12),
              Text("Listening...", style: TextStyle(color: Colors.white70)),
            ],
          ),
        );
    }
  }

  Widget _buildDesktopActionButton() {
     String label = "START";
    IconData icon = Icons.play_arrow;
    Color color = AppTheme.accent;

    if (currentMode == TranslationMode.signToText) {
      label = isCameraActive ? "STOP" : "START";
      icon = isCameraActive ? Icons.stop : Icons.play_arrow;
      color = isCameraActive ? Colors.redAccent : AppTheme.accent;
    } else if (currentMode == TranslationMode.textToSign) {
      label = "TRANSLATE";
      icon = Icons.translate;
    } else {
      label = "LISTEN";
      icon = Icons.mic;
    }

    return ElevatedButton.icon(
      onPressed: onToggleCamera,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: 50, height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white10,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildLabelChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}