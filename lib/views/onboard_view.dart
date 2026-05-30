import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.title,
    required this.description,
    required this.imag,
    required this.onNext,
    required this.onSkip,
  });
  final String title;
  final String imag;
  final String description;
  final void Function() onNext;
  final void Function() onSkip;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            description,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),

            child: Image.asset(imag),
          ),
          Spacer(flex: 2),
          SizedBox(
            height: 65,
            width: 300,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 65,
            width: 300,
            child: TextButton(
              onPressed: onSkip,
              child: Text('Skip', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
