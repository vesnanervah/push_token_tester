import 'dart:convert';

import 'dart:typed_data';

import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart';

const _mockRequestDelay = Duration(milliseconds: 400);

class MockGoogleAuthClient extends AuthClient {
  @override
  void close() {}

  @override
  AccessCredentials get credentials => AccessCredentials(
    AccessToken('type', 'data', DateTime.now()),
    'example',
    [],
  );

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _makeFakeCall();

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      _makeFakeCall();

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _makeFakeCall();

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _makeFakeCall();

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _makeFakeCall();

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _makeFakeCall();

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw UnimplementedError();
  }

  Future<Response> _makeFakeCall() =>
      Future.delayed(_mockRequestDelay, () => Response('', 200));
}
