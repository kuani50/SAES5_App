import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/raid_registration/registration_stepper.dart';
import '../widgets/raid_registration/team_creation_step.dart';
import '../widgets/raid_registration/teammates_step.dart';
import '../widgets/raid_registration/docs_step.dart';
import '../widgets/raid_registration/validation_step.dart';

class RaidRegistrationScreen extends StatefulWidget {
  final String? raidName; 
  final int initialStep;

  const RaidRegistrationScreen({
    super.key,
    this.raidName,
    this.initialStep = 2,
  });

  @override
  State<RaidRegistrationScreen> createState() => _RaidRegistrationScreenState();
}

class _RaidRegistrationScreenState extends State<RaidRegistrationScreen> {
  late int _currentStep;
  final _teamNameController = TextEditingController();

  bool _marieDocUploaded = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(1, 5);
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 5) _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 1) _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Inscription : ${widget.raidName ?? 'Raid Urbain Caen'}",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.close, size: 16, color: Colors.black),
              label: const Text(
                "Annuler",
                style: TextStyle(color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Stepper
              RegistrationStepper(currentStep: _currentStep),
              const SizedBox(height: 48),

              Expanded(
                child: SingleChildScrollView(child: _buildCurrentStep()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 2:
        return TeamCreationStep(
          teamNameController: _teamNameController,
          onNext: _nextStep,
        );
      case 3:
        return TeammatesStep(onNext: _nextStep, onPrev: _prevStep);
      case 4:
        return DocsStep(
          marieDocUploaded: _marieDocUploaded,
          onUploadMarieDoc: () {
            setState(() {
              _marieDocUploaded = true;
            });
          },
          onNext: _nextStep,
          onPrev: _prevStep,
        );
      case 5:
        return ValidationStep(
          onConfirm: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Inscription confirmée !")),
            );
            context.go('/my-races');
          },
          onPrev: _prevStep,
        );
      default:
        // Default to Team Creation
        return TeamCreationStep(
          teamNameController: _teamNameController,
          onNext: _nextStep,
        );
    }
  }
}
