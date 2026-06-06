import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;
  final IconData icon;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : hintText,
              style: TextStyle(
                color: selectedDate != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
