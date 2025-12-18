import 'package:flutter/material.dart';

class ThemedTextField extends StatelessWidget {
  const ThemedTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.width,
    this.height,
  });
  final TextEditingController controller;
  final void Function() onChanged;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
      ),
      child: TextField(
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        controller: controller,
        keyboardType: keyboardType,
        onEditingComplete: () => onChanged(),
        onTapOutside: (_) => onChanged(),
      ),
    );
  }
}
