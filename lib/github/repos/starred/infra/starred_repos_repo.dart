import 'package:dartz/dartz.dart';
import 'package:repo_viewer/core/domain/fresh.dart';
import 'package:repo_viewer/core/infra/network_exceptions.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/core/infra/github_repo_dto.dart';
import 'package:repo_viewer/github/repos/starred/infra/starred_repos_remote_service.dart';

class StarredReposRepo {
  final StarredReposRemoteService _remoteService;
  // TODO: local service

  StarredReposRepo(this._remoteService);

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getStarredReposPage(
    int page,
  ) async {
    try {
      final items = await _remoteService.getStarredReposPage(page);
      return right(items.when(
        // TODO: Get data from local service.
        noConnection: (maxPage) => Fresh.no(
          [],
          more: page < maxPage,
        ),
        // TODO: Get data from local service.
        notModified: (maxPage) => Fresh.yes(
          [],
          more: page < maxPage,
        ),
        // TODO: Save data to local service.
        withNewData: (data, maxPage) => Fresh.yes(
          data.toDomain(),
          more: page < maxPage,
        ),
      ));
    } on RestApiException catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}

extension GithubReposDTOConverter on List<GithubRepoDTO> {
  List<GithubRepo> toDomain() {
    return map((e) => e.toDomain()).toList();
  }
}
