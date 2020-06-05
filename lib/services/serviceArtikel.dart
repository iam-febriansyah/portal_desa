import 'dart:io';

import 'package:dio/dio.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/models/modelArtikelEdit.dart';
import 'package:retrofit/http.dart';

part 'serviceArtikel.g.dart';

@RestApi(baseUrl: ConfigURL.url)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("artikel/addberita")
  Future<ModelAfterPost> postAddEdit(
    @Field("id") String id,
    @Field("judul") String judul,
    @Field("tanggal") String tanggal,
    @Field("penulis") String penulis,
    @Field("status") String status,
    @Field("isi") String isi,
    @Field("kategori") String kategori,
    @Field("jenis") String jenis,
    @Field("ipaddress") String ipaddress,
    @Field("username") String username,
    @Field("kodedesa") String kodedesa,
    @Field("gambar") File gambar

  );

  @POST("artikel/editberitanotupload")
  Future<ModelAfterPost> postEditNotUpload(
    @Field("id") String id,
    @Field("judul") String judul,
    @Field("tanggal") String tanggal,
    @Field("penulis") String penulis,
    @Field("status") String status,
    @Field("isi") String isi,
    @Field("kategori") String kategori,
    @Field("jenis") String jenis,
    @Field("ipaddress") String ipaddress,
    @Field("username") String username,
    @Field("kodedesa") String kodedesa

  );

  @POST("artikel/uploadgambar")
  Future<ModelAfterPost> uploadgambar(
    @Field("gambar") File gambar
  );

  @POST("artikel/deleteberita")
  Future<ModelAfterPost> postDelete(
    @Field("id") String id
  );

  @POST("artikel/addberita")
  Future<ModelAfterPost> postInsert(
    @Field("id") String id
  );

  @GET("artikel/daftarberita")
  Future<ModelArtikel> getData(
    @Query("kodedesa") String kodedesa,
  );

  @GET("artikel/beritaedit")
  Future<ModelArtikelEdit> getBeritaEdit(
    @Query("id") String id,
  );

}

RestClient getClientArtikel(){
  final dio = Dio();
  dio.options.headers["content-type"] = "application/x-www-form-urlencoded";
  dio.options.connectTimeout = 60000;

  RestClient client = RestClient(dio);
  return client;
}