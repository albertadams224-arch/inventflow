import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PictureBox extends StatefulWidget {
  const PictureBox({super.key, required this.callBack});

  final Function(File) callBack;
  @override
  State<PictureBox> createState() => _PictureBoxState();
}

class _PictureBoxState extends State<PictureBox> {
  File? _image;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
      widget.callBack(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: colorScheme.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Take a picture',
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
