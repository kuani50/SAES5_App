  import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:saps5app/models/project.dart';
import 'package:saps5app/providers/project_provider.dart';
import 'package:saps5app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate Mocks
@GenerateMocks([Dio, ApiService])
import 'unit_test.mocks.dart';

void main() {
  group('Project Model Test', () {
    test('fromJson creates a Project correctly', () {
      final json = {
        "id": 1,
        "title": "Test Project",
        "description": "Desc",
        "image": "projects/img.jpg",
        "category": "Test",
        "created_at": "2026-01-01T12:00:00.000Z",
        "updated_at": "2026-01-02T12:00:00.000Z"
      };

      final project = Project.fromJson(json);

      expect(project.id, 1);
      expect(project.title, "Test Project");
      expect(project.category, "Test");
      expect(project.createdAt.year, 2026);
    });

    test('getFullImageUrl returns correct URL', () {
      final project = Project(
        id: 1,
        title: "T",
        description: "D",
        image: "projects/img.jpg",
        category: "C",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final url = project.getFullImageUrl("http://example.com");
      expect(url, "http://example.com/storage/projects/img.jpg");
    });
  });

  group('ApiService Test', () {
    late MockDio mockDio;
    late ApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = ApiService(baseUrl: "http://test.com", dio: mockDio);
    });

    test('fetchProjects returns list of projects on 200', () async {
      final mockResponse = {
        "id": 1,
        "title": "Test",
        "description": "Desc",
        "image": "img.jpg",
        "category": "Cat",
        "created_at": "2026-01-01T00:00:00.000Z",
        "updated_at": "2026-01-01T00:00:00.000Z"
      };

      when(mockDio.get('http://test.com/api/projects')).thenAnswer(
        (_) async => Response(
          data: [mockResponse],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final projects = await apiService.fetchProjects();
      expect(projects.length, 1);
      expect(projects.first.title, "Test");
    });

    test('fetchProjects throws exception on error', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(apiService.fetchProjects(), throwsException);
    });
  });

  group('ProjectProvider Test', () {
    late MockApiService mockApiService;
    late ProjectProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockApiService = MockApiService();
      provider = ProjectProvider(apiService: mockApiService);
    });

    test('Initial state is correct', () {
      expect(provider.projects, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, null);
    });

    test('fetchProjects updates state on success', () async {
      final project = Project(
        id: 1,
        title: "Test",
        description: "D",
        category: "C",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiService.fetchProjects()).thenAnswer((_) async => [project]);

      await provider.fetchProjects();

      expect(provider.isLoading, false);
      expect(provider.projects.length, 1);
      expect(provider.error, null);
    });

    test('fetchProjects updates state on failure', () async {
      when(mockApiService.fetchProjects())
          .thenThrow(Exception("Network Error"));

      await provider.fetchProjects();

      expect(provider.isLoading, false);
      expect(provider.projects, isEmpty);
      expect(provider.error, contains("Network Error"));
    });
  });
}
