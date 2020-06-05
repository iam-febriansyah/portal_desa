// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serviceGalery.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'http://desabintangsari.id/api/';
  }

  final Dio _dio;

  @override
  postDelete(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'id': id});
    final _result = await _dio.request('galeri/deleteGaleri',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getData(kodedesa, jenis) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    ArgumentError.checkNotNull(jenis, 'jenis');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'kodedesa': kodedesa,
      'jenis': jenis
    };
    const _data = null;
    final _result = await _dio.request('galeri/daftargaleri',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelGaleri.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getGaleriEdit(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'id': id};
    const _data = null;
    final _result = await _dio.request('galeri/galeriedit',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelGaleriEdit.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postInsertFoto(
      kodedesa, judul, keterangan, id, idkategori, jenis, gambar) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    ArgumentError.checkNotNull(judul, 'judul');
    ArgumentError.checkNotNull(keterangan, 'keterangan');
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(idkategori, 'idkategori');
    ArgumentError.checkNotNull(jenis, 'jenis');
    ArgumentError.checkNotNull(gambar, 'gambar');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({
      'kodedesa': kodedesa,
      'judul': judul,
      'keterangan': keterangan,
      'id': id,
      'idkategori': idkategori,
      'jenis': jenis,
      'gambar':
          UploadFileInfo(gambar, gambar.path.split(Platform.pathSeparator).last)
    });
    final _result = await _dio.request('galeri/addgaleri',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postInsertVideo(
      kodedesa, judul, keterangan, id, idkategori, jenis, video) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    ArgumentError.checkNotNull(judul, 'judul');
    ArgumentError.checkNotNull(keterangan, 'keterangan');
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(idkategori, 'idkategori');
    ArgumentError.checkNotNull(jenis, 'jenis');
    ArgumentError.checkNotNull(video, 'video');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({
      'kodedesa': kodedesa,
      'judul': judul,
      'keterangan': keterangan,
      'id': id,
      'idkategori': idkategori,
      'jenis': jenis,
      'video': video
    });
    final _result = await _dio.request('galeri/addgaleri',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }
}
