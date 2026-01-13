import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class LicenseSection extends StatefulWidget {
  final TextEditingController licenseController;

  const LicenseSection({super.key, required this.licenseController});

  @override
  State<LicenseSection> createState() => _LicenseSectionState();
}

class _LicenseSectionState extends State<LicenseSection> {
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Oui"),
                value: true,
                groupValue: _isLicensed,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    _isLicensed = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Non"),
                value: false,
                groupValue: _isLicensed,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    _isLicensed = value;
                    widget.licenseController.clear();
                  });
                },
              ),
            ),
          ],
        ),
        
        if (_isLicensed == true) ...[
          const SizedBox(height: 16),
          CustomTextField(
            label: "Numéro de licence",
            hintText: "Ex: 12345678",
            controller: widget.licenseController,
          ),
        ],
      ],
    );
  }
}
