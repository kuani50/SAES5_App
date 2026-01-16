import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../models/course_model.dart';
import '../models/raid_model.dart';
import '../models/user_model.dart';
import '../widgets/raid_registration/registration_stepper.dart';
import '../widgets/raid_registration/team_creation_step.dart';
import '../widgets/raid_registration/teammates_step.dart';
import '../widgets/raid_registration/docs_step.dart';
import '../widgets/raid_registration/validation_step.dart';
import '../providers/auth_provider.dart';
import '../providers/api_provider.dart';

class RaidRegistrationScreen extends StatefulWidget {
  final String? raidName;
  final CourseModel? course;
  final RaidModel? raid;
  final int initialStep;

  const RaidRegistrationScreen({
    super.key,
    this.raidName,
    this.course,
    this.raid,
    this.initialStep = 1,
  });

  @override
  State<RaidRegistrationScreen> createState() => _RaidRegistrationScreenState();
}

class _RaidRegistrationScreenState extends State<RaidRegistrationScreen> {
  late int _currentStep;
  final _teamNameController = TextEditingController();

  // State for Registration Flow
  final List<UserModel> _teammates = [];
  final Map<int, File> _uploadedDocs = {};

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(
      1,
      4,
    ); // Steps 1-4 (Team, Members, Docs, Validation)

    // Initialize with current user as captain
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = context.read<AuthProvider>().currentUser;
      if (currentUser != null) {
        setState(() {
          _teammates.add(currentUser);
        });
      }
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 4) _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 1) _currentStep--;
    });
  }

  void _addTeammate(UserModel user) {
    if (!_teammates.any((u) => u.id == user.id)) {
      setState(() {
        _teammates.add(user);
      });
    }
  }

  void _removeTeammate(UserModel user) {
    // Cannot remove captain (index 0)
    if (_teammates.indexOf(user) > 0) {
      setState(() {
        _teammates.remove(user);
        _uploadedDocs.remove(user.id);
      });
    }
  }

  void _onUploadDoc(int userId, File file) {
    setState(() {
      _uploadedDocs[userId] = file;
    });
  }

  bool _isSubmitting = false;

  Future<void> _submitRegistration() async {
    if (_teamNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nom d'équipe")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final api = context.read<ApiProvider>().apiClient;
      final currentUser = context.read<AuthProvider>().currentUser;
      if (currentUser == null) throw Exception("Utilisateur non connecté");

      // 1. Upload Documents (optional - don't block registration if upload fails)
      for (var entry in _uploadedDocs.entries) {
        final userId = entry.key;
        final file = entry.value;
        try {
          await api.uploadDocument(file, userId);
          debugPrint("Document uploaded successfully for user $userId");
        } catch (e) {
          debugPrint("Error uploading doc for user $userId: $e");
          // Continue with registration even if document upload fails
        }
      }

      // 2. Prepare Team Data

      final members = _teammates
          .map(
            (u) => {'user_id': u.id, 'is_captain': _teammates.indexOf(u) == 0},
          )
          .toList();

      final body = {
        'name': _teamNameController.text,
        'race_id': widget.course?.id, // course.id is the race_id in the backend
        'manager_id': currentUser.id,
        'members': members,
      };

      // 3. Create Team - this is the real API call
      await api.createTeamWithMembers(body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inscription confirmée avec succès !"),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to User Races Tab
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Erreur lors de l'inscription";

        // Try to extract a user-friendly message from the error
        if (e is DioException && e.response != null) {
          final responseData = e.response!.data;
          if (responseData is Map) {
            // Extract the main message
            if (responseData.containsKey('message')) {
              errorMessage = responseData['message'].toString();
            }
            // Add conflict details if available
            if (responseData.containsKey('conflicts') &&
                responseData['conflicts'] is List) {
              final conflicts = responseData['conflicts'] as List;
              if (conflicts.isNotEmpty) {
                final conflict = conflicts.first;
                if (conflict is Map && conflict.containsKey('user')) {
                  errorMessage +=
                      "\n${conflict['user']} - ${conflict['conflicting_race'] ?? ''} (${conflict['dates'] ?? ''})";
                }
              }
            }
          } else if (responseData is String) {
            errorMessage = responseData;
          }
        } else {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool _isCaptainParticipating = true;

  void _onCaptainParticipationChanged(bool? value) {
    if (value != null) {
      setState(() {
        _isCaptainParticipating = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Inscription : ${widget.raidName ?? 'Raid'}",
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
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Stepper
                  RegistrationStepper(currentStep: _currentStep),
                  const SizedBox(height: 40),

                  // Step Content
                  Expanded(
                    child: SingleChildScrollView(child: _buildStepContent()),
                  ),
                ],
              ),
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return TeamCreationStep(
          teamNameController: _teamNameController,
          onNext: () {
            if (_teamNameController.text.isNotEmpty) {
              _nextStep();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Veuillez entrer un nom d'équipe"),
                ),
              );
            }
          },
        );
      case 2:
        return TeammatesStep(
          teammates: _teammates,
          isCaptainParticipating: _isCaptainParticipating,
          onCaptainParticipationChanged: _onCaptainParticipationChanged,
          onAddTeammate: _addTeammate,
          onRemoveTeammate: _removeTeammate,
          onNext: _nextStep,
          onPrev: _prevStep,
        );
      case 3:
        return DocsStep(
          teammates: _teammates,
          isCaptainParticipating: _isCaptainParticipating,
          uploadedDocs: _uploadedDocs,
          onUploadDoc: _onUploadDoc,
          onNext: _nextStep,
          onPrev: _prevStep,
        );
      case 4:
        return ValidationStep(
          teammates: _teammates,
          isCaptainParticipating: _isCaptainParticipating,
          course: widget.course,
          onConfirm: _submitRegistration,
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
