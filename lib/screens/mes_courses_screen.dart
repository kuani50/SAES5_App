import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../models/course_model.dart';
import '../widgets/header_home_page.dart';

class MesCoursesScreen extends StatefulWidget {
  const MesCoursesScreen({super.key});

  @override
  State<MesCoursesScreen> createState() => _MesCoursesScreenState();
}

class _MesCoursesScreenState extends State<MesCoursesScreen> {
  List<CourseModel> _courses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchManagedCourses();
  }

  Future<void> _fetchManagedCourses() async {
    try {
      final apiProvider = context.read<ApiProvider>();
      final authProvider = context.read<AuthProvider>();

      if (!authProvider.isAuthenticated) {
        setState(() {
          _error = "Vous devez être connecté";
          _isLoading = false;
        });
        return;
      }

      // Fetch courses managed by the current user using ApiClient
      final dynamic response = await apiProvider.apiClient.getManagedRaces();

      var coursesList = <dynamic>[];
      if (response is List) {
        coursesList = response;
      } else if (response is Map && response.containsKey('data')) {
        coursesList = response['data'] as List<dynamic>;
      } else {
        debugPrint('Unknown format for managed races: $response');
      }

      final courses = coursesList
          .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
          .toList();

      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching managed courses: $e');
      // Fallback to mock data for visualization if API fails or doesn't exist yet
      if (mounted) {
        setState(() {
          _courses = [
            CourseModel(
              id: 1,
              name: "Course du Printemps",
              raidId: 0,
              managerId: 1,
              type: "Compétition",
              difficulty: "Moyen",
              gender: "Mixte",
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(hours: 4)),
              maxParticipants: 400,
              maxTeams: 100,
              maxPersonsPerTeam: 4,
              minParticipants: 10,
              minTeams: 5,
              minPrice: 50.0,
              majPrice: 60.0,
              reducedPrice: 40.0,
              isChipMandatory: true,
              minAge: 18,
              independentAge: 18,
              supervisorAge: 21,
              remainingTeams: 25,
            ),
            CourseModel(
              id: 2,
              name: "Trail des Collines",
              raidId: 0,
              managerId: 1,
              type: "Loisir",
              difficulty: "Facile",
              gender: "Mixte",
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(hours: 2)),
              maxParticipants: 100,
              maxTeams: 50,
              maxPersonsPerTeam: 2,
              minParticipants: 10,
              minTeams: 5,
              minPrice: 20.0,
              majPrice: 30.0,
              reducedPrice: 15.0,
              isChipMandatory: false,
              minAge: 12,
              independentAge: 16,
              supervisorAge: 18,
              remainingTeams: 30, // 20 enrolled
            ),
            CourseModel(
              id: 3,
              name: "Marathon Nocturne",
              raidId: 0,
              managerId: 1,
              type: "Compétition",
              difficulty: "Difficile",
              gender: "Mixte",
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(hours: 6)),
              maxParticipants: 600,
              maxTeams: 200,
              maxPersonsPerTeam: 3,
              minParticipants: 10,
              minTeams: 5,
              minPrice: 80,
              majPrice: 100,
              reducedPrice: 60,
              isChipMandatory: true,
              minAge: 20,
              independentAge: 20,
              supervisorAge: 25,
              remainingTeams: 20, // 180 enrolled
            ),
          ];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mes Courses",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 32),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Text(
                  "Erreur: $_error",
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_courses.isEmpty)
              const Center(
                child: Text(
                  "Vous n'avez aucune course à gérer.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              _buildCoursesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTable() {
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
                    "NOM DE LA COURSE",
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
                    "TYPE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "PLACES RESTANTES",
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
          ..._courses.map(
            (course) => _CourseRow(
              course: course,
              onManage: () => _onManageCourse(course),
              onDelete: () => _onDeleteCourse(course),
            ),
          ),
        ],
      ),
    );
  }

  void _onManageCourse(CourseModel course) {
    context.push('/manage-course', extra: course);
  }

  Future<void> _onDeleteCourse(CourseModel course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la course"),
        content: Text(
          "Voulez-vous vraiment supprimer la course '${course.name}' ?\nCette action est irréversible.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Supprimer",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final apiProvider = context.read<ApiProvider>();
        // API call to delete the course using ApiClient
        await apiProvider.apiClient.deleteRace(course.id);

        if (mounted) {
          setState(() {
            _courses.removeWhere((c) => c.id == course.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Course '${course.name}' supprimée")),
          );
        }
      } catch (e) {
        debugPrint("Error deleting course: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur lors de la suppression : $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class _CourseRow extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onManage;
  final VoidCallback onDelete;

  const _CourseRow({
    required this.course,
    required this.onManage,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final enrolledTeams =
        course.maxTeams - (course.remainingTeams ?? course.maxTeams);
    final totalTeams = course.maxTeams;
    final progress = totalTeams > 0 ? enrolledTeams / totalTeams : 0.0;

    // Choose color based on fill percentage
    Color progressColor;
    if (progress < 0.5) {
      progressColor = Colors.green;
    } else if (progress < 0.8) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Course Name
          Expanded(
            flex: 3,
            child: Text(
              course.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          // Type Badge
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _TypeBadge(type: course.type),
            ),
          ),

          // Remaining Places with Progress Bar
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$enrolledTeams / $totalTeams",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onManage,
                  icon: const Icon(Icons.settings, size: 16),
                  label: const Text("Gérer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text("Supprimer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    // Choose color based on type
    Color bgColor;
    Color textColor;

    switch (type.toLowerCase()) {
      case 'compétition':
      case 'competition':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      case 'loisir':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
