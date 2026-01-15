import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/raid_data.dart';
import '../widgets/raid_list_section.dart';
import '../widgets/header_home_page.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderHomePage(isLoggedIn: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroBanner(
              title: 'Prochain défi : Raid Suisse Normande',
              onTap: () {
                context.push('/details', extra: allRaids[0]);
              },
            ),
            const SizedBox(height: 16),
            RaidListSection(raids: allRaids),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
