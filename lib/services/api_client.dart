import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/project.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/api/projects")
  Future<List<Project>> getProjects();

  @POST("/api/mobile/login")
  Future<String> login(@Body() Map<String, dynamic> body);

  @POST("/api/mobile/register")
  Future<String> register(@Body() Map<String, dynamic> body);
}
