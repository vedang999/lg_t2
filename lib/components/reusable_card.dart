import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({
    required this.colour,
    this.cardChild,
    required this.onPress,
    this.loading = false, // New loading parameter
  });

  final Color colour;
  final Widget? cardChild;
  final Function() onPress;
  final bool loading; // Added loading parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            cardChild ?? Container(), // Show the card child
            if (loading)
              Center( // Show loading indicator if loading is true
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
