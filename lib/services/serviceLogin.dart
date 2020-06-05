import 'package:dio/dio.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/models/modelHome.dart';
import 'package:portal_desa/models/modelLogin.dart';
import 'package:portal_desa/models/modelUser.dart';
import 'package:retrofit/http.dart';

part 'serviceLogin.g.dart';

@RestApi(baseUrl: ConfigURL.url)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("login/proseslogin")
  Future<ModelLogin> postLogin(
    @Field("username") String username,
    @Field("password") String password,
  );

  @GET("login/home")
  Future<ModelHome> getHome(
    @Query("kodedesa") String kodedesa
  );

  @GET("login/user")
  Future<UserDetail> getUser(
    @Query("username") String username
  );

  @POST("login/changepassword")
  Future<ModelAfterPost> postChangePassword(
    @Field("id") String id,
    @Field("password") String password,
  );

  
}

RestClient getClientLogin(){
  final dio = Dio();
  dio.options.headers["content-type"] = "application/x-www-form-urlencoded";
  dio.options.connectTimeout = 60000;

  RestClient client = RestClient(dio);
  return client;
}