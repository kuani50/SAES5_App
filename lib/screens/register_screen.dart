import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/club_model.dart';
import '../providers/auth_provider.dart';
import '../providers/api_provider.dart';
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
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _dateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: "France");
  final _complementAddressController = TextEditingController();

  DateTime? _selectedDate;
  ClubModel? _selectedClub;
  bool? _isLicensed;
  String? _selectedGender;

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext screenContext) async {
    final DateTime? picked = await showDatePicker(
      context: screenContext,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (dialogContext, child) {
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
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _selectedGender ?? 'M', // Default to Male if not selected
        _phoneController.text.trim(),
        _selectedDate?.toIso8601String() ?? '',
        _addressController.text.trim(),
        _postalCodeController.text.trim(),
        _cityController.text.trim(),
        _countryController.text.trim(),
        _complementAddressController.text.trim(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erreur lors de l'inscription."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  List<ClubModel> _clubs = [];
  bool _isLoadingClubs = true;

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  Future<void> _fetchClubs() async {
    try {
      final apiProvider = context.read<ApiProvider>();
      debugPrint('Fetching clubs...');
      final dynamic response = await apiProvider.apiClient.getClubs();
      debugPrint('Clubs response type: ${response.runtimeType}');
      debugPrint('Clubs response data: $response');

      var clubsList = <dynamic>[];
      if (response is List) {
        clubsList = response;
      } else if (response is Map && response.containsKey('data')) {
        clubsList = response['data'] as List<dynamic>;
      } else {
        debugPrint('Unknown format for clubs: $response');
      }

      final clubs = clubsList
          .map((json) {
            try {
              return ClubModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              debugPrint('Error parsing club: $e, data: $json');
              return null;
            }
          })
          .whereType<ClubModel>()
          .toList();

      debugPrint('Parsed ${clubs.length} clubs');

      setState(() {
        _clubs = clubs;
        _isLoadingClubs = false;
      });
    } catch (e) {
      debugPrint('Error fetching clubs: $e');
      setState(() {
        _isLoadingClubs = false;
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
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
                  // ... (rest of the inputs)
                  const SizedBox(height: 32),

                  // Gender Dropdown
                  const Text(
                    "Civilité *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    hint: const Text("Sélectionner"),
                    items: const [
                      DropdownMenuItem(value: "M", child: Text("Monsieur")),
                      DropdownMenuItem(value: "F", child: Text("Madame")),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedGender = value),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) => value == null
                        ? "Veuillez sélectionner une civilité"
                        : null,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "Prénom *",
                          hintText: "Thomas",
                          controller: _firstNameController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Le prénom est requis.'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: "Nom *",
                          hintText: "Dupont",
                          controller: _lastNameController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Le nom est requis.'
                              : null,
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
                        validator: (value) => value == null || value.isEmpty
                            ? 'La date est requise.'
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address Fields
                  CustomTextField(
                    label: "Adresse *",
                    hintText: "123 Rue de la Liberté",
                    controller: _addressController,
                    validator: (value) => value == null || value.isEmpty
                        ? "L'adresse est requise"
                        : null,
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Complément d'adresse (facultatif)",
                    hintText: "Bâtiment A, Appartement 12",
                    controller: _complementAddressController,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "Code Postal *",
                          hintText: "75000",
                          controller: _postalCodeController,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Requis.' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: "Ville *",
                          hintText: "Paris",
                          controller: _cityController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requise.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: "Pays *",
                    hintText: "France",
                    controller: _countryController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Requis.' : null,
                  ),
                  const SizedBox(height: 24),

                  LicenseSection(
                    licenseController: _licenseController,
                    isLicensed: _isLicensed,
                    onLicenseChanged: (value) {
                      setState(() {
                        _isLicensed = value;
                        if (value == false) {
                          _licenseController.clear();
                          _selectedClub = null;
                        }
                      });
                    },
                    validator: (value) {
                      if (_isLicensed == true) {
                        if (value == null || value.isEmpty) {
                          return 'Le numéro de licence est requis.';
                        }
                        if (value.length != 6 || int.tryParse(value) == null) {
                          return 'Le numéro doit comporter 6 chiffres.';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  if (_isLicensed == true) ...[
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Choisir votre club *",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_isLoadingClubs)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          DropdownButtonFormField<ClubModel>(
                            initialValue: _selectedClub,
                            hint: Text(
                              "Sélectionner un club...",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _clubs.map((ClubModel club) {
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
                            validator: (value) => value == null
                                ? "Veuillez sélectionner un club"
                                : null,
                          ),
                      ],
                    ),
                  ],

                  CustomTextField(
                    label: "Téléphone *",
                    hintText: "0601020304",
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le téléphone est requis.';
                      }
                      if (value.length < 10) {
                        return 'Numéro invalide (10 chiffres).';
                      }
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
                      if (value == null || value.isEmpty) {
                        return 'L\'email est requis.';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Format d\'email invalide.';
                      }
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
                      if (value == null || value.isEmpty) {
                        return 'Le mot de passe est requis.';
                      }
                      if (value.length < 8) {
                        return 'Le mot de passe doit faire au moins 8 caractères.';
                      }
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
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer le mot de passe.';
                      }
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas.';
                      }
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
      ),
    );
  }
}
