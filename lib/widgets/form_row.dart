import 'package:flutter/material.dart';

class FormRow extends StatelessWidget {
  const FormRow({super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label, textAlign: TextAlign.right)),
          SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}
