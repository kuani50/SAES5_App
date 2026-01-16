import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/raid_model.dart';
import '../models/course_model.dart';
import '../providers/auth_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;
  final RaidModel raid;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.raid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Retour au raid',
          style: TextStyle(color: Colors.orange, fontSize: 16),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseHeader(course: course, raid: raid),
            const SizedBox(height: 16),
            CourseInfoGrid(course: course),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CourseHeader extends StatelessWidget {
  final CourseModel course;
  final RaidModel raid;

  const CourseHeader({super.key, required this.course, required this.raid});

  String _getAddressText() {
    if (raid.address != null) {
      final addr = raid.address!;
      final parts = <String>[];
      if (addr.address != null && addr.address!.isNotEmpty) {
        parts.add(addr.address!);
      }
      if (addr.postalCode != null && addr.postalCode!.isNotEmpty) {
        parts.add(addr.postalCode!);
      }
      if (addr.city != null && addr.city!.isNotEmpty) {
        parts.add(addr.city!);
      }
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    return "Adresse non disponible";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green.shade100),
                          ),
                          child: Text(
                            course.difficulty,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _getAddressText(),
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Organisé par ${raid.club?.name ?? 'Club #${raid.clubId}'}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final authProvider = context.read<AuthProvider>();

                      if (authProvider.isAuthenticated) {
                        // Navigate to team registration
                        context.push(
                          '/raid-registration',
                          extra: {'course': course, 'raid': raid},
                        );
                      } else {
                        // Redirect to login
                        context.push('/login?redirect=/details');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "S'inscrire à la course",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseInfoGrid extends StatelessWidget {
  final CourseModel course;

  const CourseInfoGrid({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return GridView.count(
          crossAxisCount: isWide ? 3 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isWide ? 1.5 : 2.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _InfoCard(
              title: "DATES",
              icon: Icons.calendar_today,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Début : ${DateFormat('dd MMM yyyy', 'fr_FR').format(course.startDate)}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Fin : ${DateFormat('dd MMM yyyy', 'fr_FR').format(course.endDate)}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _InfoCard(
              title: "ÉQUIPES",
              icon: Icons.people,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personnes par équipe : ${course.maxPersonsPerTeam}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Max d'équipes : ${course.maxTeams}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _InfoCard(
              title: "CATÉGORIE",
              icon: Icons.local_offer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _Tag(
                        text: course.gender,
                        color: Colors.blue.shade50,
                        textColor: Colors.blue.shade700,
                      ),
                      _Tag(
                        text: course.type,
                        color: Colors.purple.shade50,
                        textColor: Colors.purple.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _InfoCard(
              title: "TARIFS",
              icon: Icons.euro,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mineur : ${course.minPrice}€", // Assuming minPrice roughly maps or is displayed
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Majeur : ${course.majPrice}€",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Réduit : ${course.reducedPrice}€",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (course.mealPrice != null)
                    Text(
                      "Repas : ${course.mealPrice}€",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
            _InfoCard(
              title: "CONDITIONS D'ÂGE",
              icon: Icons.person,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Âge minimum : ${course.minAge} ans",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Autonome dès : ${course.independentAge} ans",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Encadrant dès : ${course.supervisorAge} ans",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _InfoCard(
              title: "INFORMATIONS",
              icon: Icons.info,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(
                          text: "Puce obligatoire : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: course.isChipMandatory ? "Oui" : "Non",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Responsable #${course.managerId}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
