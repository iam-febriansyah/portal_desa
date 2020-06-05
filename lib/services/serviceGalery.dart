import 'dart:io';

import 'package:dio/dio.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/models/modelGaleriEdit.dart';
import 'package:portal_desa/models/modelGalery.dart';
import 'package:retrofit/http.dart';

part 'serviceGalery.g.dart';

@RestApi(baseUrl: ConfigURL.url)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("galeri/deleteGaleri")
  Future<ModelAfterPost> postDelete(
    @Field("id") String id
  );

  @GET("galeri/daftargaleri")
  Future<ModelGaleri> getData(
    @Query("kodedesa") String kodedesa,
    @Query("jenis") String jenis
  );

  @GET("galeri/galeriedit")
  Future<ModelGaleriEdit> getGaleriEdit(
    @Query("id") String id,
  );

  @POST("galeri/addgaleri")
  Future<ModelAfterPost> postInsertFoto(
    @Field("kodedesa") String kodedesa,
		@Field("judul") String judul,
		@Field("keterangan") String keterangan,
    @Field("id") String id,
    @Field("idkategori") String idkategori,
    @Field("jenis") String jenis,
    @Field("gambar") File gambar,
  );

  @POST("galeri/addgaleri")
  Future<ModelAfterPost> postInsertVideo(
    @Field("kodedesa") String kodedesa,
		@Field("judul") String judul,
		@Field("keterangan") String keterangan,
    @Field("id") String id,
    @Field("idkategori") String idkategori,
    @Field("jenis") String jenis,
    @Field("video") String video
  );

  

}

RestClient getClientGaleri(){
  final dio = Dio();
  dio.options.headers["content-type"] = "application/x-www-form-urlencoded";
  dio.options.connectTimeout = 60000;

  RestClient client = RestClient(dio);
  return client;
}