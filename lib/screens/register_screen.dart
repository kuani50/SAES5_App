import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../models/club_model.dart'; //
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
  // Key for form state management and validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _dateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Date management.
  DateTime? _selectedDate;
  //  Selected club state.
  ClubModel? _selectedClub;

  // Loading state for submission button.
  bool _isLoading = false;

  // The context passed here is the valid one from the screen.
  Future<void> _selectDate(BuildContext screenContext) async {
    final DateTime? picked = await showDatePicker(
      context: screenContext,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      // locale: const Locale("fr"), // Removed to prevent crash if localizations are not setup
      builder: (dialogContext, child) {
        // Use the screenContext to find the theme, not the dialogContext.
        return Theme(
          data: Theme.of(screenContext).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Handles form submission.
  void _submit() {
    // Check if all validators pass.
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);


      Future.delayed(const Duration(seconds: 2), () {

        if (!mounted) return;

        setState(() => _isLoading = false);
        context.go('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // Local club list as an alternative to dummy_data.dart.
    // This makes the widget self-contained and ready for a future provider.
    final List<ClubModel> clubs = [
      ClubModel(name: "Orient'Express", location: "Caen, 14", description: "Club..."),
      ClubModel(name: "ALBE Orientation", location: "Elbeuf, 76", description: "Club..."),
      ClubModel(name: "Vikings 76", location: "Rouen, 76", description: "Club..."),
      ClubModel(name: "ASL Condé", location: "Condé-sur-Noireau, 14", description: "Club..."),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            // Form widget to enable validation.
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Inscription",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "Prénom *",
                          hintText: "Thomas",
                          controller: _firstNameController,
                          validator: (value) => value == null || value.isEmpty ? 'Le prénom est requis.' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: "Nom *",
                          hintText: "Dupont",
                          controller: _lastNameController,
                          validator: (value) => value == null || value.isEmpty ? 'Le nom est requis.' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: "Date de naissance *",
                        hintText: "jj/mm/aaaa",
                        controller: _dateController,
                        validator: (value) => value == null || value.isEmpty ? 'La date est requise.' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  LicenseSection(licenseController: _licenseController),
                  const SizedBox(height: 24),

                  // Club dropdown field.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Choisir votre club (facultatif)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ClubModel>(
                        value: _selectedClub,
                        hint: Text("Sélectionner un club...", style: TextStyle(color: Colors.grey.shade400)),
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.orange, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: clubs.map((ClubModel club) {
                          return DropdownMenuItem<ClubModel>(
                            value: club,
                            child: Text(club.name),
                          );
                        }).toList(),
                        onChanged: (ClubModel? newValue) {
                          setState(() {
                            _selectedClub = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Téléphone *",
                    hintText: "0601020304",
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Le téléphone est requis.';
                      if (value.length < 10) return 'Numéro invalide (10 chiffres).';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Email *",
                    hintText: "thomas@exemple.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'L\'email est requis.';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Format d\'email invalide.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Mot de passe *",
                    hintText: "Entrez votre mot de passe",
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Le mot de passe est requis.';
                      if (value.length < 8) return 'Le mot de passe doit faire au moins 8 caractères.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Confirmer le mot de passe *",
                    hintText: "Confirmez votre mot de passe",
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Veuillez confirmer le mot de passe.';
                      if (value != _passwordController.text) return 'Les mots de passe ne correspondent pas.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  PrimaryButton(
                    text: "S'inscrire",
                    onPressed: _submit,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Déjà un compte ? "),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          "Connectez-vous",
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
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
      ),
    );
  }
}
