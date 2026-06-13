import 'package:flutter/material.dart';
import 'package:inventflow/widgets/input_fields.dart';

class ShowModalBottomSheets extends StatelessWidget {
  const ShowModalBottomSheets({super.key});

  @override
  Widget build(BuildContext context) {
    var kLargeTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.bold);
    return Container(
      height: 500,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [
            SizedBox(height: 50),
            InputFields(
              controller: TextEditingController(),
              label: 'Quantity',
              hintText: 'qty 0.00',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(double.infinity, 70),
              ),
              onPressed: () {},
              child: Text(
                'Save',
                style: kLargeTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
