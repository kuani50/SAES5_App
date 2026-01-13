import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/license_section.dart';
import '../widgets/header_home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  
  // Date Management
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default 18 years
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Simple format dd/mm/yyyy
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Slightly wider than login
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Inscription",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 32),

                // First Name / Last Name Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Prénom *",
                        hintText: "Thomas",
                        controller: _firstNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: "Nom *",
                        hintText: "Dupont",
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Date of birth (with picker)
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer( // Prevents keyboard opening
                    child: CustomTextField(
                      label: "Date de naissance *",
                      hintText: "jj/mm/aaaa",
                      controller: _dateController,
                      // Could add suffix icon here, keeping it simple for now.
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // License Section (Special Logic)
                LicenseSection(licenseController: _licenseController),
                const SizedBox(height: 24),

                // Club (Simulated Dropdown or simple TextField)
                // Using TextField to respect "Input" design, ideally DropdownButtonFormField
                const CustomTextField(
                  label: "Choisir votre club (facultatif)",
                  hintText: "Sélectionner un club...",
                ),
                const SizedBox(height: 24),

                // Phone
                CustomTextField(
                  label: "Téléphone (facultatif)",
                  hintText: "0601020304",
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(height: 24),

                // Email
                CustomTextField(
                  label: "Email *",
                  hintText: "thomas@exemple.com",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 40),

                // Validate Button
                PrimaryButton(
                  text: "S'inscrire",
                  onPressed: () {
                    // TODO: Registration logic
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 16),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Déjà un compte ? "),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        "Connectez-vous",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}