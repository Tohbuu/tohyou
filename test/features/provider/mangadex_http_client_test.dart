import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:tohyou/features/provider/data/mangadex_http_client.dart';

void main() {
  group('MangaDexHttpClient', () {
    test('gets manga details', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          expect(request.method, 'GET');
          expect(
            request.url.toString(),
            'https://api.mangadex.org/manga/manga-1',
          );

          return http.Response(
            jsonEncode(<String, dynamic>{
              'result': 'ok',
              'response': 'entity',
              'data': <String, dynamic>{'id': 'manga-1'},
            }),
            200,
          );
        }),
      );

      final result = await client.getManga('manga-1');

      expect(result['result'], 'ok');
      expect(result['data']['id'], 'manga-1');
    });

    test('searches manga with a title parameter', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          expect(request.url.path, '/manga');
          expect(request.url.queryParameters['title'], 'One Piece');

          return http.Response(
            jsonEncode(<String, dynamic>{'result': 'ok', 'data': <dynamic>[]}),
            200,
          );
        }),
      );

      final result = await client.searchManga('One Piece');

      expect(result['result'], 'ok');
    });

    test('gets chapters for a manga', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          expect(request.url.path, '/chapter');
          expect(request.url.queryParameters['manga'], 'manga-1');

          return http.Response(
            jsonEncode(<String, dynamic>{'result': 'ok', 'data': <dynamic>[]}),
            200,
          );
        }),
      );

      final result = await client.getChapters('manga-1');

      expect(result['result'], 'ok');
    });

    test('gets chapter pages', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          expect(request.url.path, '/at-home/server/chapter-1');

          return http.Response(
            jsonEncode(<String, dynamic>{
              'result': 'ok',
              'baseUrl': 'https://uploads.mangadex.org',
            }),
            200,
          );
        }),
      );

      final result = await client.getChapterPages('chapter-1');

      expect(result['result'], 'ok');
      expect(result['baseUrl'], 'https://uploads.mangadex.org');
    });

    test('throws on non-success responses', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          return http.Response('Not found', 404);
        }),
      );

      expect(
        () => client.getManga('missing'),
        throwsA(
          isA<MangaDexHttpException>().having(
            (error) => error.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });

    test('throws when the response is not a JSON object', () async {
      final client = MangaDexHttpClient(
        httpClient: MockClient((request) async {
          return http.Response(jsonEncode(<String>['invalid']), 200);
        }),
      );

      expect(
        () => client.getManga('manga-1'),
        throwsA(
          isA<MangaDexHttpException>().having(
            (error) => error.statusCode,
            'statusCode',
            200,
          ),
        ),
      );
    });
  });
}
