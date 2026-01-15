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

  @GET("/api/raids-with-club-and-address")
  Future<List<RaidModel>> getRaids();

  @GET("/api/club")
  Future<List<ClubModel>> getClubs();

  @GET("/api/clubsWithUpcomingEvents")
  Future<List<ClubModel>> getClubsWithUpcomingEvents();

  @GET("/api/raid/{raid}/races")
  Future<List<CourseModel>> getRacesByRaid(@Path("raid") int raidId);

  @GET("/api/club/{club}/raids")
  Future<List<RaidModel>> getRaidsByClub(@Path("club") int clubId);

  @POST("/api/mobile/login")
  Future<String> login(@Body() Map<String, dynamic> body);

  @POST("/api/mobile/register")
  Future<String> register(@Body() Map<String, dynamic> body);
}
