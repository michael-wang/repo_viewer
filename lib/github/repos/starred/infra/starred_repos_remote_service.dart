import 'package:dio/dio.dart';
import 'package:repo_viewer/core/infra/remote_response.dart';
import 'package:repo_viewer/github/core/infra/github_repo_dto.dart';

class StarredReposRemoteService {
  final Dio dio;

  StarredReposRemoteService(this.dio);

  Future<RemoteResponse<List<GithubRepoDTO>>> getStarredReposPage(
      int page) async {}
}
