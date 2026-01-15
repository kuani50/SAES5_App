import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final IconData? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: TextEditingController(text: initialValue),
            decoration: InputDecoration(
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, size: 18, color: Colors.black54)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
