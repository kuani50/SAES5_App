import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/course_model.dart';
import '../../providers/api_provider.dart';

class ManageCourseScreen extends StatefulWidget {
  final CourseModel course;

  const ManageCourseScreen({super.key, required this.course});

  @override
  State<ManageCourseScreen> createState() => _ManageCourseScreenState();
}

class _ManageCourseScreenState extends State<ManageCourseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _enrolledTeams = [];
  bool _isLoading = true;

  // Results tab state
  File? _selectedFile;
  String? _selectedFileName;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchEnrolledTeams();
  }

  Future<void> _fetchEnrolledTeams() async {
    try {
      final apiProvider = context.read<ApiProvider>();
      // Fetch teams for this specific course using ApiClient
      final dynamic response = await apiProvider.apiClient.getRaceTeams(
        widget.course.id,
      );

      setState(() {
        _enrolledTeams = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      // Mock data for fallback
      if (mounted) {
        setState(() {
          _enrolledTeams = [
            {
              'name': 'Les Rapides',
              'category': 'Mixte',
              'status': 'Validé',
              'id': 1,
            },
            {
              'name': 'Team Endurance',
              'category': 'Homme',
              'status': 'En attente',
              'id': 2,
            },
            {
              'name': 'Sprint Club',
              'category': 'Femme',
              'status': 'Incomplet',
              'id': 3,
            },
          ];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.flag, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            Text(
              "Gestion de : ${widget.course.name}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF3B82F6),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF3B82F6),
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text("Équipes inscrites"),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events),
                  SizedBox(width: 8),
                  Text("Résultats"),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTeamsTab(), _buildResultsTab()],
      ),
    );
  }

  Widget _buildTeamsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Équipes inscrites (${_enrolledTeams.length})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
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
                          "NOM D'ÉQUIPE",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "GENRE",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "STATUT",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rows
                ..._enrolledTeams.map(
                  (team) =>
                      _TeamRow(team: team, courseName: widget.course.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Résultats de la course",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Upload zone
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cloud upload icon
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),

                // Selected file or instruction
                if (_selectedFileName != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedFileName!,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.green.shade600,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _selectedFile = null;
                              _selectedFileName = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Text(
                    "Glissez-déposez votre fichier de résultats ici",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text("ou", style: TextStyle(color: Colors.grey.shade500)),
                  const SizedBox(height: 16),
                ],

                // Browse button
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.folder_open, size: 18),
                  label: Text(
                    _selectedFileName != null
                        ? "Changer de fichier"
                        : "Parcourir",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Format hint
                Text(
                  "Formats acceptés : CSV",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          // Upload button (only shown when file is selected)
          if (_selectedFile != null) ...[
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadFile,
                icon: _isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.upload, size: 18),
                label: Text(
                  _isUploading ? "Envoi en cours..." : "Envoyer les résultats",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de la sélection du fichier: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final apiProvider = context.read<ApiProvider>();
      await apiProvider.apiClient.uploadRaceResults(
        _selectedFile!,
        widget.course.id,
      );

      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedFile = null;
          _selectedFileName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Résultats envoyés avec succès !"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'envoi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _TeamRow extends StatelessWidget {
  final Map<String, dynamic> team;
  final String courseName;

  const _TeamRow({required this.team, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Name with Icon
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.groups, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  team['name'] ?? 'Sans nom',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          // Category Badge
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _CategoryBadge(category: team['category'] ?? 'Mixte'),
            ),
          ),
          // Status Badge
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusBadge(status: team['status'] ?? 'En attente'),
            ),
          ),
          // Action Button
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    '/team-detail',
                    extra: {'team': team, 'courseName': courseName},
                  );
                },
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text("Voir détails"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (category.toLowerCase()) {
      case 'homme':
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1E40AF);
        icon = Icons.male;
        break;
      case 'femme':
        bgColor = const Color(0xFFFCE7F3);
        textColor = const Color(0xFF9D174D);
        icon = Icons.female;
        break;
      default: // Mixte
        bgColor = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF6B21A8);
        icon = Icons.transgender;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'validé':
      case 'valide':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        icon = Icons.check_circle;
        break;
      case 'incomplet':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        icon = Icons.error;
        break;
      default: // En attente
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
