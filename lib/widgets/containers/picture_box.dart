import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureBox extends StatefulWidget {
  const PictureBox({super.key, required this.callBack});

  final Function(Uint8List) callBack;
  @override
  State<PictureBox> createState() => _PictureBoxState();
}

class _PictureBoxState extends State<PictureBox> {
  Uint8List? _imageBytes;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      widget.callBack(bytes);
    }
  }

  void _showSourceOptions() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('Take a picture'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _showSourceOptions,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
        ),
        child: _imageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: colorScheme.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add a picture',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
