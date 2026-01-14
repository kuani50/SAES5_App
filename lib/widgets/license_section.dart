import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class LicenseSection extends StatelessWidget {
  final TextEditingController licenseController;
  final bool? isLicensed;
  final ValueChanged<bool?> onLicenseChanged;

  const LicenseSection({
    super.key,
    required this.licenseController,
    required this.isLicensed,
    required this.onLicenseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Êtes-vous licencié ? *",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildChoiceButton(
                label: "Oui",
                isSelected: isLicensed == true,
                onTap: () => onLicenseChanged(true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceButton(
                label: "Non",
                isSelected: isLicensed == false,
                onTap: () => onLicenseChanged(false),
              ),
            ),
          ],
        ),

        // Dynamic field display
        if (isLicensed == true) ...[
          const SizedBox(height: 24),
          CustomTextField(
            label: "Numéro de licence",
            hintText: "Ex: 12345678",
            controller: licenseController,
          ),
        ],
      ],
    );
  }

  // Helper to build a clean selection button
  Widget _buildChoiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.orange : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
