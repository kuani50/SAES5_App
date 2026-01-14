import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/raid_model.dart';
import 'raid_card.dart';

class RaidListSection extends StatelessWidget {
  final List<RaidModel> raids;

  const RaidListSection({super.key, required this.raids});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Tous les raids', // Updated text slightly to match
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.30,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: raids.length,
          itemBuilder: (context, index) {
            final raid = raids[index];
            return RaidCard(
              raid: raid,
              onTap: () {
                context.push('/details', extra: raid);
              },
            );
          },
        ),
      ],
    );
  }
}
