import 'package:dio/dio.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/models/modePengumumanEdit.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/models/modelPengumuman.dart';
import 'package:retrofit/http.dart';

part 'servicePengumuman.g.dart';

@RestApi(baseUrl: ConfigURL.url)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("pengumuman/deletepengumuman")
  Future<ModelAfterPost> postDelete(
    @Field("id") String id
  );

  @POST("pengumuman/addpengumuman")
  Future<ModelAfterPost> postInsert(
    @Field("id") String id,
    @Field("pengumuman") String pengumuman,
    @Field("kodedesa") String kodedesa
  );

  @POST("pengumuman/kirimbroadcast")
  Future<ModelAfterPost> postBroadcast(
    @Field("id") String id,
    @Field("kodedesa") String kodedesa
  );

  @GET("pengumuman/daftarpengumuman")
  Future<ModelPengumuman> getDataPengumuman(
    @Query("kodedesa") String kodedesa
  );

  @GET("pengumuman/pengumumanedit")
  Future<ModelPengumumanEdit> getPengumumanEdit(
    @Query("id") String id,
  );

  

}

RestClient getClientPengumuman(){
  final dio = Dio();
  dio.options.headers["content-type"] = "application/x-www-form-urlencoded";
  dio.options.connectTimeout = 60000;

  RestClient client = RestClient(dio);
  return client;
}