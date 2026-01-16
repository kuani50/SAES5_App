import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/course_model.dart';
import '../models/raid_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final RaidModel raid;
  final bool isRegistered;

  const CourseCard({
    super.key,
    required this.course,
    required this.raid,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourseInfo(course: course),
                const SizedBox(height: 16),
                CourseActions(
                  isMobile: true,
                  course: course,
                  raid: raid,
                  isRegistered: isRegistered,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: CourseInfo(course: course)),
                CourseActions(
                  isMobile: false,
                  course: course,
                  raid: raid,
                  isRegistered: isRegistered,
                ),
              ],
            ),
    );
  }
}

// --- Sub-component: Course Info ---
class CourseInfo extends StatelessWidget {
  final CourseModel course;

  const CourseInfo({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _CourseTag(text: "Par équipe de ${course.maxPersonsPerTeam}"),
            const SizedBox(width: 8),
            _CourseTag(text: course.difficulty),
            const SizedBox(width: 8),
            _CourseTag(
              text:
                  "${course.maxTeams - (course.remainingTeams ?? course.maxTeams)}/${course.maxTeams} équipes inscrites",
            ),
          ],
        ),
      ],
    );
  }
}

// --- Sub-component: Action Buttons ---
class CourseActions extends StatelessWidget {
  final bool isMobile;
  final CourseModel course;
  final RaidModel raid;
  final bool isRegistered;

  const CourseActions({
    super.key,
    required this.isMobile,
    required this.course,
    required this.raid,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMobile
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => context.push(
            '/course-details',
            extra: {'course': course, 'raid': raid},
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Voir les détails',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isRegistered
              ? null
              : () {
                  final authProvider = context.read<AuthProvider>();

                  if (authProvider.isAuthenticated) {
                    // Navigate to registration screen with course and raid data
                    context.push(
                      '/raid-registration',
                      extra: {'course': course, 'raid': raid},
                    );
                  } else {
                    // Redirect to login with redirect back to this course registration
                    context.push('/login?redirect=/details');
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isRegistered
                ? Colors.grey.shade400
                : Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRegistered) ...[
                const Icon(Icons.check_circle, size: 16),
                const SizedBox(width: 6),
              ],
              Text(
                isRegistered ? "Déjà inscrit" : "S'inscrire",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Sub-component: Generic Tag ---
class _CourseTag extends StatelessWidget {
  final String text;

  const _CourseTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
