// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serviceArtikel.dart';

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
  postAddEdit(id, judul, tanggal, penulis, status, isi, kategori, jenis,
      ipaddress, username, kodedesa, gambar) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(judul, 'judul');
    ArgumentError.checkNotNull(tanggal, 'tanggal');
    ArgumentError.checkNotNull(penulis, 'penulis');
    ArgumentError.checkNotNull(status, 'status');
    ArgumentError.checkNotNull(isi, 'isi');
    ArgumentError.checkNotNull(kategori, 'kategori');
    ArgumentError.checkNotNull(jenis, 'jenis');
    ArgumentError.checkNotNull(ipaddress, 'ipaddress');
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    ArgumentError.checkNotNull(gambar, 'gambar');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'penulis': penulis,
      'status': status,
      'isi': isi,
      'kategori': kategori,
      'jenis': jenis,
      'ipaddress': ipaddress,
      'username': username,
      'kodedesa': kodedesa,
      'gambar':
          UploadFileInfo(gambar, gambar.path.split(Platform.pathSeparator).last)
    });
    final _result = await _dio.request('artikel/addberita',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postEditNotUpload(id, judul, tanggal, penulis, status, isi, kategori, jenis,
      ipaddress, username, kodedesa) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(judul, 'judul');
    ArgumentError.checkNotNull(tanggal, 'tanggal');
    ArgumentError.checkNotNull(penulis, 'penulis');
    ArgumentError.checkNotNull(status, 'status');
    ArgumentError.checkNotNull(isi, 'isi');
    ArgumentError.checkNotNull(kategori, 'kategori');
    ArgumentError.checkNotNull(jenis, 'jenis');
    ArgumentError.checkNotNull(ipaddress, 'ipaddress');
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'penulis': penulis,
      'status': status,
      'isi': isi,
      'kategori': kategori,
      'jenis': jenis,
      'ipaddress': ipaddress,
      'username': username,
      'kodedesa': kodedesa
    });
    final _result = await _dio.request('artikel/editberitanotupload',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  uploadgambar(gambar) async {
    ArgumentError.checkNotNull(gambar, 'gambar');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({
      'gambar':
          UploadFileInfo(gambar, gambar.path.split(Platform.pathSeparator).last)
    });
    final _result = await _dio.request('artikel/uploadgambar',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postDelete(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'id': id});
    final _result = await _dio.request('artikel/deleteberita',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postInsert(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'id': id});
    final _result = await _dio.request('artikel/addberita',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getData(kodedesa) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'kodedesa': kodedesa};
    const _data = null;
    final _result = await _dio.request('artikel/daftarberita',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelArtikel.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getBeritaEdit(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'id': id};
    const _data = null;
    final _result = await _dio.request('artikel/beritaedit',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelArtikelEdit.fromJson(_result.data);
    return Future.value(value);
  }
}
