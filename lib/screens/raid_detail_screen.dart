import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/raid_model.dart';
import '../widgets/course_card.dart';

class RaidDetailScreen extends StatelessWidget {
  final RaidModel raid;

  const RaidDetailScreen({super.key, required this.raid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 150,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          label: const Text(
            "Retour aux raids",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header sub-component
            RaidDetailHeader(raid: raid),

            const SizedBox(height: 40),
            const Text(
              "Les Courses",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),

            // Course List
            if (raid.courses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Aucune course disponible pour le moment."),
              )
            else
              ...raid.courses.map(
                (course) => CourseCard(course: course, raid: raid),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Detail Header Sub-component ---
class RaidDetailHeader extends StatelessWidget {
  final RaidModel raid;

  const RaidDetailHeader({super.key, required this.raid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          raid.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _InfoItem(icon: Icons.calendar_today, text: raid.date),
            _InfoItem(icon: Icons.location_on, text: raid.location),
            Text(
              "(${raid.clubName})",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Small helper for icon+text ---
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
