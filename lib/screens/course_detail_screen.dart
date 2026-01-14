import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/raid_model.dart';
import '../models/course_model.dart';

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
                    Row(
                      children: [
                        const Icon(
                          Icons.flag_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          course.distance,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          raid.location,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.people_outline,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          course.organizer ?? "Inconnu",
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
                      // Subscribe action
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
                  Text(
                    "${course.remainingTeams ?? 0} place(s) restante(s)",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
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
                    "Début : ${course.startDate != null ? DateFormat('dd MMM yyyy', 'fr_FR').format(course.startDate!) : '-'}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Fin : ${course.endDate != null ? DateFormat('dd MMM yyyy', 'fr_FR').format(course.endDate!) : '-'}",
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
                    "Personnes par équipe : ${course.teamSize}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Équipes inscrites : ${(course.maxTeams ?? 0) - (course.remainingTeams ?? 0)} / ${course.maxTeams ?? '-'}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _InfoCard(
              title: "CATÉGORIE",
              icon: Icons.local_offer,
              child: Row(
                children: [
                  _Tag(
                    text: course.category ?? "Mixte",
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade700,
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
                    "Mineur : ${course.priceJunior}€",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Majeur : ${course.priceAdult}€",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Réduit : ${course.priceReduced}€",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Repas : ${course.priceMeal}€",
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
                    "Autonome dès : ${course.autonomousAge} ans",
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
                          text: course.chipRequired == true ? "Oui" : "Non",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Responsable : ${course.organizer}",
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
