import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/raid_model.dart';
import '../models/course_model.dart';
import '../widgets/course_card.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';

class RaidDetailScreen extends StatefulWidget {
  final RaidModel raid;

  const RaidDetailScreen({super.key, required this.raid});

  @override
  State<RaidDetailScreen> createState() => _RaidDetailScreenState();
}

class _RaidDetailScreenState extends State<RaidDetailScreen> {
  List<CourseModel> _courses = [];
  Set<int> _registeredRaceIds = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchCourses(), _fetchUserTeams()]);
  }

  Future<void> _fetchCourses() async {
    try {
      final apiProvider = context.read<ApiProvider>();
      final dynamic responseDataReceived = await apiProvider.apiClient
          .getRacesByRaid(widget.raid.id);

      var responseData = responseDataReceived;

      // If response is a String, parse it as JSON
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      // Handle wrapped response {"races": [...]} or {"data": [...]} or direct array [...]
      List<dynamic> coursesList;

      if (responseData is Map<String, dynamic>) {
        // Check for 'races' key first (Laravel convention)
        if (responseData.containsKey('races')) {
          coursesList = responseData['races'] as List<dynamic>;
        } else if (responseData.containsKey('data')) {
          coursesList = responseData['data'] as List<dynamic>;
        } else {
          coursesList = [];
        }
      } else if (responseData is List) {
        coursesList = responseData;
      } else {
        coursesList = [];
      }

      final courses = coursesList
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
      debugPrint('Error fetching courses: $e');
    }
  }

  Future<void> _fetchUserTeams() async {
    try {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAuthenticated) {
        debugPrint('User not authenticated, skipping team fetch');
        return;
      }

      final apiProvider = context.read<ApiProvider>();
      final dynamic response = await apiProvider.apiClient.getUserTeams();

      debugPrint('getUserTeams raw response: $response');
      debugPrint('getUserTeams response type: ${response.runtimeType}');

      var responseData = response;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      List<dynamic> teamsList = [];
      if (responseData is List) {
        teamsList = responseData;
      } else if (responseData is Map) {
        debugPrint('Response is Map with keys: ${responseData.keys}');
        if (responseData.containsKey('data')) {
          teamsList = responseData['data'] as List<dynamic>;
        } else if (responseData.containsKey('teams')) {
          teamsList = responseData['teams'] as List<dynamic>;
        } else {
          // Try to find any list in the map
          for (var key in responseData.keys) {
            if (responseData[key] is List) {
              debugPrint('Found list under key: $key');
              teamsList = responseData[key] as List<dynamic>;
              break;
            }
          }
        }
      }

      debugPrint('Teams list length: ${teamsList.length}');

      // Extract race_ids from user's teams
      final raceIds = <int>{};
      for (var team in teamsList) {
        debugPrint('Team data: $team');
        if (team is Map) {
          // Try different possible key names for race_id
          final possibleKeys = ['race_id', 'raceId', 'course_id', 'courseId'];
          for (var key in possibleKeys) {
            if (team.containsKey(key)) {
              final raceId = team[key];
              debugPrint('Found $key: $raceId');
              if (raceId is int) {
                raceIds.add(raceId);
              } else if (raceId is String) {
                final parsed = int.tryParse(raceId);
                if (parsed != null) raceIds.add(parsed);
              }
              break;
            }
          }
        }
      }

      debugPrint('Registered race IDs: $raceIds');

      if (mounted) {
        setState(() {
          _registeredRaceIds = raceIds;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user teams: $e');
      // Non-blocking error, continue showing courses
    }
  }

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
            RaidDetailHeader(raid: widget.raid),

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
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text("Erreur: $_error", style: const TextStyle(color: Colors.red))
            else if (_courses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Aucune course disponible pour le moment."),
              )
            else
              ..._courses.map(
                (course) => CourseCard(
                  course: course,
                  raid: widget.raid,
                  isRegistered: _registeredRaceIds.contains(course.id),
                ),
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
    // Basic date formatting
    final startStr =
        "${raid.startDate.day}/${raid.startDate.month}/${raid.startDate.year}";
    final endStr =
        "${raid.endDate.day}/${raid.endDate.month}/${raid.endDate.year}";
    final dateDisplay = startStr == endStr ? startStr : "$startStr - $endStr";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          raid.name,
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
            _InfoItem(icon: Icons.calendar_today, text: dateDisplay),
            _InfoItem(
              icon: Icons.location_on,
              text: raid.address != null
                  ? "${raid.address!.city ?? ''} ${raid.address!.postalCode ?? ''}"
                  : "Adresse #${raid.addressId}",
            ),
            if (raid.club != null)
              Text(
                "(${raid.club!.name})",
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
