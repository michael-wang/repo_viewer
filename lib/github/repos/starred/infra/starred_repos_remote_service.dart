import 'dart:io';

import 'package:dio/dio.dart';
import 'package:repo_viewer/core/infra/dio_extensions.dart';
import 'package:repo_viewer/core/infra/network_exceptions.dart';
import 'package:repo_viewer/core/infra/remote_response.dart';
import 'package:repo_viewer/core/shared/globals.dart';
import 'package:repo_viewer/github/core/infra/github_headers.dart';
import 'package:repo_viewer/github/core/infra/github_headers_cache.dart';
import 'package:repo_viewer/github/core/infra/github_repo_dto.dart';

class StarredReposRemoteService {
  final Dio _dio;
  final GithubHeadersCache _headersCache;

  StarredReposRemoteService(
    this._dio,
    this._headersCache,
  );

  Future<RemoteResponse<List<GithubRepoDTO>>> getStarredReposPage(
      int page) async {
    const token = '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';
    const accept = 'application/vnd.github.v3+json';
    final reqURL = Uri.https(
      'api.github.com',
      '/user/starred',
      {'page': page},
    );

    try {
      final prevHeaders = await _headersCache.read(reqURL);
      final resp = await _dio.getUri(
        reqURL,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            'Accept': accept,
            'If-None-Match': prevHeaders?.eTag ?? '',
          },
        ),
      );

      if (resp.statusCode == HttpStatus.ok) {
        // Later request need headers like: 'ETag' or 'Link', so save them to
        // cache.
        final headers = GithubHeaders.parse(resp);
        await _headersCache.save(reqURL, headers);

        // Parse list of repos.
        final data = (resp.data as List<dynamic>)
            .map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>))
            .toList();
        return RemoteResponse.withNewData(data);
      } else if (resp.statusCode == HttpStatus.notModified) {
        return const RemoteResponse.notModified();
      } else {
        log.w('Unexpected API response code: ${resp.statusCode}');
        throw RestApiException(resp.statusCode);
      }
    } on DioError catch (err) {
      if (err.isNoConnection) {
        throw const RemoteResponse.noConnection();
      } else if (err.response != null) {
        throw RestApiException(err.response!.statusCode);
      } else {
        rethrow;
      }
    }
    return const RemoteResponse.withNewData([]);
  }
}
