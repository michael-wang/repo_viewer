import 'package:collection/collection.dart';
import 'package:repo_viewer/core/infra/sembast_database.dart';
import 'package:repo_viewer/github/core/infra/github_repo_dto.dart';
import 'package:sembast/sembast.dart';

class StarredReposLocalService {
  final SembastDatabase _db;
  final _store = intMapStoreFactory.store('starredRepos');

  StarredReposLocalService(this._db);

  // Update or insert one page of github repos to db with int key.
  // The saved keys would be: 0, 1, 2, ...
  // Page index is one based (as github API returns), but we'll convert to zero
  // based internally.
  Future<void> upsertPage(List<GithubRepoDTO> repos, int oneBasedPage) async {
    // We want to use zero based index for page.
    final zeroBasedPage = oneBasedPage - 1;
    _store
        .records(repos
            .mapIndexed((index, _) => zeroBasedPage * repos.length + index))
        .put(_db.instance, repos.map((e) => e.toJson()).toList());
  }
}
