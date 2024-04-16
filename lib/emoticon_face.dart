import 'package:flutter/material.dart';

class EmoticonFace extends StatelessWidget {
  final String emoticonFace;
  final VoidCallback? onTap;
  final bool isHighlighted; // New parameter to indicate highlighting

  const EmoticonFace({
    Key? key,
    required this.emoticonFace,
    this.onTap,
    this.isHighlighted = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Update decoration based on isHighlighted
    BoxDecoration decoration = BoxDecoration(
      color: isHighlighted ? Colors.red : Colors.blue, // Highlight in red
      borderRadius: BorderRadius.circular(12),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            emoticonFace,
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
