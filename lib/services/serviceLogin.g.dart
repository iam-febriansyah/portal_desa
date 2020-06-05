// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serviceLogin.dart';

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
  postLogin(username, password) async {
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'username': username, 'password': password});
    final _result = await _dio.request('login/proseslogin',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelLogin.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getHome(kodedesa) async {
    ArgumentError.checkNotNull(kodedesa, 'kodedesa');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'kodedesa': kodedesa};
    const _data = null;
    final _result = await _dio.request('login/home',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = ModelHome.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getUser(username) async {
    ArgumentError.checkNotNull(username, 'username');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'username': username};
    const _data = null;
    final _result = await _dio.request('login/user',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = UserDetail.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  postChangePassword(id, password) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from({'id': id, 'password': password});
    final _result = await _dio.request('login/changepassword',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    var value = ModelAfterPost.fromJson(_result.data);
    return Future.value(value);
  }
}
