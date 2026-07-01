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
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: Color(0xFFFCEBEB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFF09595), width: 0.5),
      ),
      content: Row(
        children: [
          Icon(Icons.cancel_outlined, color: Color(0xFFA32D2D)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Color(0xFF501313),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Color(0xFFA32D2D),
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
    final product = await _av.buildProduct();
    ref.read(inventoryProvider.notifier).addProduct(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Item',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PictureBox(
                callBack: (image) {
                  _av.selectedImage = image;
                },
              ),
              SizedBox(height: 15),
              Text(
                'Product name',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 15),
              InputFields(
                hintText: 'e.g. Wireless headphones',
                controller: _av.nameController,
              ),
              SizedBox(height: 17),
              Row(
                children: [
                  Text(
                    'Prices(GHS)',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Stock qty',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InputFields(
                      controller: _av.pricesController,
                      hintText: '0.00',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: InputFields(
                      controller: _av.quantityController,
                      hintText: '0',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CategoryDropdown(
                onChange: (cat) {
                  _av.selectedCategory = cat;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Expiry',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      selectedDate: _av.selectedDate,
                      onTap: _pickDate,
                      hintText: 'select date',
                      icon: Icons.calendar_today,
                    ),
                  ),
                  SizedBox(width: 20),
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
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: _addProduct,
                      child: Text(
                        'Add product',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
