import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserRacesTab extends StatelessWidget {
  const UserRacesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(0, 4),
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
        ),
      ],
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
          const Text(
            "Raid Suisse Normande",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Parcours Aventure",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "12 Octobre • Équipe \"Les Gazelles\"",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Participant",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Responsable d'équipe",
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
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
    // Determine layout based on width
    final warningBadge = Container(
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

    final gererDocsBtn = ElevatedButton(
      onPressed: () {},
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
