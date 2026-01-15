import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/project.dart';
import '../models/raid_model.dart';
import '../models/club_model.dart';
import '../models/course_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/api/projects")
  Future<List<Project>> getProjects();

  @GET("/api/raids?with=club,address")
  Future<List<RaidModel>> getRaids();

  @GET("/api/clubs")
  Future<dynamic> getClubs();

  @GET("/api/clubs?with=upcoming,address")
  Future<List<ClubModel>> getClubsWithUpcomingEvents();

  @GET("/api/raids/{raid}/races")
  Future<List<CourseModel>> getRacesByRaid(@Path("raid") int raidId);

  @GET("/api/club/{club}/raids")
  Future<List<RaidModel>> getRaidsByClub(@Path("club") int clubId);

  @POST("/api/mobile/login")
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST("/api/mobile/register")
  Future<dynamic> register(@Body() Map<String, dynamic> body);

  @GET("/api/user")
  Future<dynamic> getCurrentUser();

  // Race Management
  @GET("/api/races")
  Future<dynamic> getManagedRaces();

  @DELETE("/api/races/{id}")
  Future<void> deleteRace(@Path("id") int id);

  @GET("/api/races/{id}/teams")
  Future<dynamic> getRaceTeams(@Path("id") int id);
}
