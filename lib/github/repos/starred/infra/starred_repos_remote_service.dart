import 'package:dio/dio.dart';
import 'package:repo_viewer/core/infra/remote_response.dart';
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
    return const RemoteResponse.withNewData([]);
  }
}
