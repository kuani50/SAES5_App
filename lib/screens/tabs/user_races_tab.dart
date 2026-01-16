import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';

class UserRacesTab extends StatefulWidget {
  const UserRacesTab({super.key});

  @override
  State<UserRacesTab> createState() => _UserRacesTabState();
}

class _UserRacesTabState extends State<UserRacesTab> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _registrations = [];

  @override
  void initState() {
    super.initState();
    _fetchRegistrations();
  }

  Future<void> _fetchRegistrations() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final apiProvider = context.read<ApiProvider>();

      // Get current user ID
      final currentUser = authProvider.currentUser;
      if (currentUser == null) {
        if (mounted) {
          setState(() {
            _error = "Veuillez vous connecter pour voir vos inscriptions";
            _isLoading = false;
          });
        }
        return;
      }

      final dynamic response = await apiProvider.apiClient.getUserRegistrations(
        currentUser.id,
      );

      debugPrint('getUserRegistrations response: $response');

      var responseData = response;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      List<dynamic> registrationsList = [];
      if (responseData is List) {
        registrationsList = responseData;
      } else if (responseData is Map) {
        if (responseData.containsKey('data') && responseData['data'] is List) {
          registrationsList = responseData['data'] as List<dynamic>;
        } else {
          for (var key in responseData.keys) {
            if (responseData[key] is List) {
              registrationsList = responseData[key] as List<dynamic>;
              break;
            }
          }
        }
      }

      debugPrint('Registrations found: ${registrationsList.length}');

      if (mounted) {
        setState(() {
          _registrations = registrationsList;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user registrations: $e');
      if (mounted) {
        setState(() {
          _error = "Impossible de charger les inscriptions";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchRegistrations();
              },
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    if (_registrations.isEmpty) {
      return const Center(
        child: Text(
          "Aucune inscription trouvée",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              "Mes Inscriptions",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Render List of Registrations
        ..._registrations.map(
          (registration) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _RegistrationCard(registration: registration),
          ),
        ),
      ],
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final dynamic registration;

  const _RegistrationCard({required this.registration});

  @override
  Widget build(BuildContext context) {
    // Extract data from the new API response structure
    final eventName = registration['raid_name']?.toString() ?? "Raid Inconnu";
    final courseName =
        registration['race_name']?.toString() ?? "Course Inconnue";
    final teamName = registration['tea_name']?.toString() ?? "Sans nom";

    // Format date
    String dateStr = "";
    if (registration['rac_start_date'] != null) {
      try {
        final date = DateTime.parse(registration['rac_start_date'].toString());
        dateStr = DateFormat('d MMMM yyyy', 'fr_FR').format(date);
      } catch (_) {}
    }

    final dateAndTeam = dateStr.isNotEmpty
        ? "$dateStr • Équipe \"$teamName\""
        : "Équipe \"$teamName\"";

    // Determine roles from API response
    final List<String> roles = [];
    if (registration['participate'] == true) {
      roles.add("Participant");
    }
    if (registration['is_manager'] == true) {
      roles.add("Responsable d'équipe");
    }
    if (roles.isEmpty) {
      roles.add("Membre");
    }

    // Status from API
    final bool isRegistrationComplete =
        registration['registration_complete'] == true;
    final bool hasValidated = registration['tea_has_validated'] == true;
    final bool hasPaid = registration['tea_has_paid'] == true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          if (isNarrow) {
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIconSection(context, isNarrow: true),
                      Expanded(
                        child: _buildContentSection(
                          eventName,
                          courseName,
                          dateAndTeam,
                          roles,
                          !isRegistrationComplete,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                _buildActionsSection(
                  context,
                  isNarrow: true,
                  eventName: eventName,
                  isMissingDocs: !isRegistrationComplete,
                  teamId: registration['tea_id'],
                  teamName: teamName,
                  raceName: courseName,
                  raidName: eventName,
                ),
              ],
            );
          } else {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildIconSection(context),
                  Expanded(
                    child: _buildContentSection(
                      eventName,
                      courseName,
                      dateAndTeam,
                      roles,
                      !isRegistrationComplete,
                    ),
                  ),
                  _buildActionsSection(
                    context,
                    isNarrow: false,
                    eventName: eventName,
                    isMissingDocs: !isRegistrationComplete,
                    teamId: registration['tea_id'],
                    teamName: teamName,
                    raceName: courseName,
                    raidName: eventName,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildIconSection(BuildContext context, {bool isNarrow = false}) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: isNarrow
            ? const BorderRadius.only(topLeft: Radius.circular(12))
            : const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
      ),
      child: Center(
        child: Icon(
          Icons.map_outlined,
          size: 40,
          color: Colors.blueGrey.shade300,
        ),
      ),
    );
  }

  Widget _buildContentSection(
    String eventName,
    String courseName,
    String dateAndTeam,
    List<String> roles,
    bool isMissingDocs,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            courseName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            dateAndTeam,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: roles.map((role) {
              final isResponsable = role.contains("Responsable");
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isResponsable
                      ? Colors.purple.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: isResponsable
                        ? Colors.purple.shade700
                        : Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: [
              Text(
                "Inscrit",
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (isMissingDocs)
                Text(
                  "Certificat manquant",
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(
    BuildContext context, {
    required bool isNarrow,
    required String eventName,
    required bool isMissingDocs,
    int? teamId,
    String? teamName,
    String? raceName,
    String? raidName,
  }) {
    Widget? warningBadge;

    if (isMissingDocs) {
      warningBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: 16, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Text(
              "Dossier incomplet",
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      warningBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
            const SizedBox(width: 8),
            Text(
              "Dossier complet",
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final gererDocsBtn = ElevatedButton(
      onPressed: () {
        context.go(
          Uri(
            path: '/raid-registration',
            queryParameters: {'raidName': eventName, 'initialStep': '4'},
          ).toString(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        fixedSize: const Size(140, 45),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "Gérer\nDocs",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, height: 1.1),
      ),
    );

    final modifierEquipeBtn = OutlinedButton(
      onPressed: () {
        context.push(
          '/manage-team',
          extra: {
            'teamId': teamId,
            'teamName': teamName,
            'raceName': raceName,
            'raidName': raidName,
          },
        );
      },
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(140, 45),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "Modifier\nÉquipe",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );

    if (isNarrow) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: warningBadge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: modifierEquipeBtn),
                const SizedBox(width: 12),
                Expanded(child: gererDocsBtn),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            warningBadge,
            Column(
              children: [
                gererDocsBtn,
                const SizedBox(height: 12),
                modifierEquipeBtn,
              ],
            ),
          ],
        ),
      );
    }
  }
}
