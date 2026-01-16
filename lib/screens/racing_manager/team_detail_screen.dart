import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeamDetailScreen extends StatefulWidget {
  final Map<String, dynamic> team;
  final String courseName;

  const TeamDetailScreen({
    super.key,
    required this.team,
    required this.courseName,
  });

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  late List<Map<String, dynamic>> _members;

  @override
  void initState() {
    super.initState();
    _members = List<Map<String, dynamic>>.from(
      widget.team['members'] as List<dynamic>? ?? _getMockMembers(),
    );
  }

  List<Map<String, dynamic>> _getMockMembers() {
    return [
      {
        'name': 'Jean Dupont',
        'chip_number': 'CHIP-7601',
        'license': '123456',
        'is_licensed': true,
        'pps_status': 'validated', 
        'pps_url': null,
      },
      {
        'name': 'Marie Martin',
        'chip_number': 'CHIP-4829',
        'license': null,
        'is_licensed': false,
        'pps_status': 'pending',
        'pps_url': 'https://example.com/pps/4829.pdf',
      },
    ];
  }

  void _showPpsDialog(Map<String, dynamic> member, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.description, color: Colors.blue),
            const SizedBox(width: 8),
            Text("PPS de ${member['name']}"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    "Document PPS",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member['pps_url'] ?? 'Aucun document',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Voulez-vous valider ce PPS ?",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _members[index] = {
                  ..._members[index],
                  'pps_status': 'rejected',
                };
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("PPS refusé"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Refuser"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _members[index] = {
                  ..._members[index],
                  'pps_status': 'validated',
                };
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("PPS validé avec succès"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
            ),
            child: const Text("Valider"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamName = widget.team['name'] ?? 'Équipe sans nom';
    final status = widget.team['status'] ?? 'En attente';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.flag, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            Text(
              "Gestion de : ${widget.courseName}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team header with back and status
            _buildTeamHeader(context, teamName, status),
            const SizedBox(height: 24),

            // Members section
            Text(
              "Membres de l'équipe (${_members.length})",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Members table
            _buildMembersTable(),
            const SizedBox(height: 32),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(
    BuildContext context,
    String teamName,
    String status,
  ) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.groups, color: Colors.green, size: 24),
        const SizedBox(width: 8),
        Text(
          "Équipe : $teamName",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const Spacer(),
        _StatusBadge(status: status),
      ],
    );
  }

  Widget _buildMembersTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "MEMBRE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "N° DE PUCE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "LICENCE / PPS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "ACTIONS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...List.generate(_members.length, (index) {
            return _MemberRow(
              member: _members[index],
              onViewPps: () => _showPpsDialog(_members[index], index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email de relance envoyé")),
            );
          },
          icon: const Icon(Icons.mail_outline, size: 18),
          label: const Text("Relancer par email"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Dossier validé avec succès"),
                backgroundColor: Colors.green,
              ),
            );
          },
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text("Valider le dossier"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22C55E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onViewPps;

  const _MemberRow({required this.member, required this.onViewPps});

  @override
  Widget build(BuildContext context) {
    final name = member['name'] ?? member['first_name'] ?? 'Sans nom';
    final chipNumber = member['chip_number']?.toString() ?? '-';
    final isLicensed = member['is_licensed'] == true;
    final ppsStatus =
        member['pps_status']?.toString() ?? 'none'; // validated, pending, none

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Member name with avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          // Chip number
          Expanded(
            flex: 2,
            child: Text(
              chipNumber,
              style: const TextStyle(color: Color(0xFF0F172A)),
            ),
          ),
          // License / PPS status
          Expanded(flex: 2, child: _buildLicenseBadge(isLicensed, ppsStatus)),
          // Actions
          Expanded(
            flex: 2,
            child: ppsStatus == 'pending'
                ? ElevatedButton.icon(
                    onPressed: onViewPps,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text("Voir PPS"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text("-", style: TextStyle(color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseBadge(bool isLicensed, String ppsStatus) {
    if (isLicensed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge, size: 14, color: Colors.orange.shade700),
            const SizedBox(width: 4),
            Text(
              "Licencié",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      );
    }

    // Not licensed - show PPS status
    switch (ppsStatus) {
      case 'validated':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 14, color: Color(0xFF166534)),
              SizedBox(width: 4),
              Text(
                "PPS Validé",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
        );
      case 'pending':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 14, color: Color(0xFF92400E)),
              SizedBox(width: 4),
              Text(
                "En attente",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
        );
      case 'rejected':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel, size: 14, color: Color(0xFFDC2626)),
              SizedBox(width: 4),
              Text(
                "Refusé",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        );
      default:
        return Text("-", style: TextStyle(color: Colors.grey.shade400));
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'validé':
      case 'valide':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        break;
      case 'incomplet':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      default: // En attente
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
