import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class LicenseSection extends StatefulWidget {
  final TextEditingController licenseController;

  const LicenseSection({super.key, required this.licenseController});

  @override
  State<LicenseSection> createState() => _LicenseSectionState();
}

class _LicenseSectionState extends State<LicenseSection> {
  // null = no choice, true = yes, false = no
  bool? _isLicensed; 

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
        
        // Using a Row with two custom selectable buttons instead of RadioListTile
        Row(
          children: [
            Expanded(
              child: _buildChoiceButton(
                label: "Oui",
                isSelected: _isLicensed == true,
                onTap: () {
                  setState(() {
                    _isLicensed = true;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceButton(
                label: "Non",
                isSelected: _isLicensed == false,
                onTap: () {
                  setState(() {
                    _isLicensed = false;
                    widget.licenseController.clear();
                  });
                },
              ),
            ),
          ],
        ),
        
        // Dynamic field display
        if (_isLicensed == true) ...[
          const SizedBox(height: 24),
          CustomTextField(
            label: "Numéro de licence",
            hintText: "Ex: 12345678",
            controller: widget.licenseController,
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
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}