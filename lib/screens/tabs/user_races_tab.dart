import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _UserRegistrationMock {
  final String eventName;
  final String courseName;
  final String dateAndTeam;
  final List<String> roles; // e.g. ["Participant", "Responsable"]
  final bool isComplete; // true if all docs returned etc.
  final bool isMissingDocs;

  _UserRegistrationMock({
    required this.eventName,
    required this.courseName,
    required this.dateAndTeam,
    required this.roles,
    required this.isComplete,
    required this.isMissingDocs,
  });
}

class UserRacesTab extends StatelessWidget {
  const UserRacesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data List
    final registrations = [
      _UserRegistrationMock(
        eventName: "Raid Suisse Normande",
        courseName: "Parcours Aventure",
        dateAndTeam: "12 Octobre • Équipe \"Les Gazelles\"",
        roles: ["Participant", "Responsable d'équipe"],
        isComplete: false,
        isMissingDocs: true,
      ),
      _UserRegistrationMock(
        eventName: "Raid Urbain Caen",
        courseName: "Parcours Découverte",
        dateAndTeam: "24 Novembre • Équipe \"Les Vikings\"",
        roles: ["Participant"],
        isComplete: true,
        isMissingDocs: false,
      ),
    ];

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
        ...registrations.map(
          (reg) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _RegistrationCard(registration: reg),
          ),
        ),
      ],
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final _UserRegistrationMock registration;

  const _RegistrationCard({required this.registration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // slightly lighter shadow
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          if (isNarrow) {
            // Mobile/Narrow Layout: Stacked
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIconSection(context, isNarrow: true),
                      Expanded(child: _buildContentSection()),
                    ],
                  ),
                ),
                const Divider(height: 1),
                _buildActionsSection(context, isNarrow: true),
              ],
            );
          } else {
            // Desktop/Wide Layout: Horizontal
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildIconSection(context),
                  Expanded(child: _buildContentSection()),
                  _buildActionsSection(context, isNarrow: false),
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
        color: const Color(0xFFF1F5F9), // Slate 50
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

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            registration.eventName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            registration.courseName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            registration.dateAndTeam,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: registration.roles.map((role) {
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
              if (registration.isMissingDocs)
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

  Widget _buildActionsSection(BuildContext context, {required bool isNarrow}) {
    Widget? warningBadge;

    if (registration.isMissingDocs) {
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
      // Placeholder or Success badge if needed, for now empty or check
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
        // Navigate to Event Registration Step 4 (Docs)
        // Pass event name and initialStep=4
        context.go(
          Uri(
            path: '/event-registration',
            queryParameters: {
              'eventName': registration.eventName,
              'initialStep': '4',
            },
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
        context.push('/manage-team');
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
