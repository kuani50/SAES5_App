import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/course_model.dart';

class ValidationStep extends StatelessWidget {
  final List<UserModel> teammates;
  final bool isCaptainParticipating;
  final CourseModel? course;
  final VoidCallback onConfirm;
  final VoidCallback onPrev;

  const ValidationStep({
    super.key,
    required this.teammates,
    required this.isCaptainParticipating,
    required this.course,
    required this.onConfirm,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    // Basic pricing logic.
    // real price usually in CourseModel. Assume mock if null.

    double pricePerPers = 15.0;
    // if (course?.minPrice != null) { pricePerPers = course!.minPrice; }

    int count = teammates.length;
    if (!isCaptainParticipating) {
      count = count > 0 ? count - 1 : 0;
    }

    final double total = pricePerPers * count;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Récapitulatif",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Course", style: TextStyle(fontSize: 16)),
                  Text(
                    "${course?.name ?? 'Parcourse'} (${count} pers.)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Prix par personne",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "${pricePerPers.toStringAsFixed(2)} €",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total à régler", style: TextStyle(fontSize: 18)),
                  Text(
                    "${total.toStringAsFixed(2)} €",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.orange.shade900, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Paiement sur place : Le règlement se fera le jour de la course.",
                  style: TextStyle(color: Colors.orange.shade900),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: onPrev,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text("Précédent"),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Text(
                "Confirmer l'inscription",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
