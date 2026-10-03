import 'dart:convert';

import 'package:http/http.dart' as http;

import 'mangadex_client.dart';

class MangaDexHttpClient implements MangaDexClient {
  MangaDexHttpClient({
    http.Client? httpClient,
    this.baseUrl = 'https://api.mangadex.org',
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final String baseUrl;

  @override
  Future<Map<String, dynamic>> getManga(String id) async {
    return _get('/manga/$id');
  }

  @override
  Future<Map<String, dynamic>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    return _get(
      '/manga',
      queryParameters: <String, String>{
        'title': query,
        'offset': '$offset',
        'limit': '$limit',
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getChapters(
    String mangaId, {
    int offset = 0,
    int limit = 20,
  }) async {
    return _get(
      '/chapter',
      queryParameters: <String, String>{
        'manga': mangaId,
        'offset': '$offset',
        'limit': '$limit',
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) async {
    return _get('/at-home/server/$chapterId');
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$path')
        .replace(queryParameters: queryParameters);

    final response = await _httpClient.get(
      uri,
      headers: <String, String>{'Accept': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MangaDexHttpException(
        statusCode: response.statusCode,
        message: 'MangaDex request failed',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const MangaDexHttpException(
        statusCode: 200,
        message: 'MangaDex returned an invalid response',
      );
    }

    return decoded;
  }
}

class MangaDexHttpException implements Exception {
  const MangaDexHttpException({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  String toString() {
    return 'MangaDex HTTP error ($statusCode): $message';
  }
}
