import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow({super.key, required this.label, required this.text});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 120, child: Text(label, textAlign: TextAlign.right)),
          SizedBox(width: 10),
          SizedBox(width: width / 2, child: Text(text)),
        ],
      ),
    );
  }
}
