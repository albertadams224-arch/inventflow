import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventflow/view_model/add.dart';
import 'package:inventflow/view_model/inventory.dart';
import 'package:inventflow/widgets/buttons/category_dropdown.dart';
import 'package:inventflow/widgets/date_picker_field.dart';
import 'package:inventflow/widgets/input_fields.dart';
import 'package:inventflow/widgets/containers/picture_box.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _av = AddViewModel();
  bool isLoading = false;

  @override
  void dispose() {
    _av.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _av.selectedDate = picked);
    }
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _av.expiryDate = picked);
    }
  }

  SnackBar snackbarContent(String error) {
    final colorScheme = Theme.of(context).colorScheme;
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.error, width: 0.5),
      ),
      content: Row(
        children: [
          Icon(Icons.cancel_outlined, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: colorScheme.error,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        },
      ),
    );
  }

  void _addProduct() async {
    final error = _av.validateInput();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackbarContent(error));
      return;
    }

    setState(() => isLoading = true);
    try {
      final product = await _av.buildProduct();
      await ref.read(inventoryProvider.notifier).addProduct(product);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Item',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PictureBox(
                callBack: (image) {
                  _av.selectedImage = image;
                },
              ),
              const SizedBox(height: 28),

              _sectionLabel('Product name'),
              const SizedBox(height: 10),
              InputFields(
                hintText: 'e.g. Wireless headphones',
                controller: _av.nameController,
              ),
              const SizedBox(height: 24),

              _sectionLabel('Pricing & stock'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InputFields(
                      controller: _av.pricesController,
                      hintText: 'Price (GHS)',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InputFields(
                      controller: _av.quantityController,
                      hintText: 'Stock qty',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _sectionLabel('Category'),
              const SizedBox(height: 10),
              CategoryDropdown(
                onChange: (cat) {
                  _av.selectedCategory = cat;
                },
              ),
              const SizedBox(height: 24),

              _sectionLabel('Dates'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      selectedDate: _av.selectedDate,
                      onTap: _pickDate,
                      hintText: 'Date added',
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DatePickerField(
                      selectedDate: _av.expiryDate,
                      onTap: _pickExpiry,
                      hintText: 'Expiry date',
                      icon: Icons.event,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading ? null : _addProduct,
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Add product',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorScheme.onPrimary,
                              ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
