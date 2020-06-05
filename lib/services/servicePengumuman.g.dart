// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicePengumuman.dart';

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
    final _result = await _dio.request('pengumuman/deletepengumuman',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postInsert(id, pengumuman, kodedesa) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(pengumuman, 'pengumuman');
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from(
        {'id': id, 'pengumuman': pengumuman, 'kodedesa': kodedesa});
    final _result = await _dio.request('pengumuman/addpengumuman',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postBroadcast(id, kodedesa) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'id': id, 'kodedesa': kodedesa});
    final _result = await _dio.request('pengumuman/kirimbroadcast',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getDataPengumuman(kodedesa) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'kodedesa': kodedesa};
    const _data = null;
    final _result = await _dio.request('pengumuman/daftarpengumuman',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelPengumuman.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getPengumumanEdit(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'id': id};
    const _data = null;
    final _result = await _dio.request('pengumuman/pengumumanedit',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelPengumumanEdit.fromJson(_result.data);
    return Future.value(value);
  }
}
