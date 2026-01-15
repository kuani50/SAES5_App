import 'dart:io';
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
  // Trigger rebuild

  @GET("/api/projects")
  Future<List<Project>> getProjects();

  @GET("/api/raids?with=club,address")
  Future<dynamic> getRaids();

  @GET("/api/clubs")
  Future<dynamic> getClubs();

  @GET("/api/clubs?with=upcoming,address")
  Future<dynamic> getClubsWithUpcomingEvents();

  @GET("/api/raids/{raid}/races")
  Future<dynamic> getRacesByRaid(@Path("raid") int raidId);

  @GET("/api/club/{club}/raids")
  Future<List<RaidModel>> getRaidsByClub(@Path("club") int clubId);

  @POST("/api/mobile/login")
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST("/api/mobile/register")
  Future<dynamic> register(@Body() Map<String, dynamic> body);

  @GET("/api/user")
  Future<dynamic> getCurrentUser();

  @GET("/api/users/search")
  Future<dynamic> searchUsers(@Query("q") String query);

  @GET("/api/user/teams")
  Future<dynamic> getUserTeams();

  @POST("/api/teams/register")
  Future<dynamic> createTeamWithMembers(@Body() Map<String, dynamic> body);

  // PPS / Documents
  @POST("/api/pps/upload")
  @MultiPart()
  Future<dynamic> uploadDocument(
    @Part(name: "file") File file,
    @Part(name: "user_id")
    int? userId, // Optional if uploading for another user
  );

  @GET("/api/pps/user/{userId}")
  Future<dynamic> getPpsByUser(@Path("userId") int userId);

  // Race Management

  // Race Management
  @GET("/api/races")
  Future<dynamic> getManagedRaces();

  @DELETE("/api/races/{id}")
  Future<void> deleteRace(@Path("id") int id);

  @GET("/api/races/{id}/teams")
  Future<dynamic> getRaceTeams(@Path("id") int id);

  // File upload for race results
  @POST("/api/races/file/upload")
  @MultiPart()
  Future<dynamic> uploadRaceResults(
    @Part(name: "file") File file,
    @Part(name: "race_id") int raceId,
  );
}
