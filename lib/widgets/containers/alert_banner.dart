import 'package:flutter/material.dart';

class AlertBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color themeColor;
  final VoidCallback onDismissed;

  const AlertBanner({
    required super.key,
    required this.message,
    required this.icon,
    required this.themeColor,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight, // Puts the icon on the right side
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      onDismissed: (direction) {
        onDismissed();
      },

      ///Visual Allert
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                border: Border.all(color: themeColor.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(icon, color: themeColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
