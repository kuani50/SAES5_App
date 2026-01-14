import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/raid_model.dart';
import 'raid_card.dart';

class RaidListSection extends StatefulWidget {
  final List<RaidModel> raids;

  const RaidListSection({super.key, required this.raids});

  @override
  State<RaidListSection> createState() => _RaidListSectionState();
}

class _RaidListSectionState extends State<RaidListSection> {
  late List<RaidModel> _filteredRaids;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredRaids = widget.raids;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_filteredRaids.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "Aucun raid trouvé.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        else
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
            itemCount: _filteredRaids.length,
            itemBuilder: (context, index) {
              final raid = _filteredRaids[index];
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
