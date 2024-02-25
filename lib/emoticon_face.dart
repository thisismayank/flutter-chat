import 'package:flutter/material.dart';

class EmoticonFace extends StatelessWidget {
  final String emoticonFace;
  final VoidCallback? onTap; // Add an onTap callback

  const EmoticonFace({
    Key? key,
    required this.emoticonFace,
    this.onTap, // Initialize in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the onTap callback
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Text(emoticonFace,
              style: TextStyle(fontSize: 28)), // Use the emoticonFace parameter
        ),
      ),
    );
  }
}
