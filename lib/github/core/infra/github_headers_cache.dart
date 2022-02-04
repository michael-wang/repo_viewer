import 'package:repo_viewer/core/infra/sembast_database.dart';
import 'package:repo_viewer/github/core/infra/github_headers.dart';
import 'package:sembast/sembast.dart';

class GithubHeadersCache {
  final SembastDatabase _db;
  final _store = stringMapStoreFactory.store('github-response-key');

  GithubHeadersCache(this._db);

  // Suggest using request URL as key, the URL that got those response headers.
  Future<void> save(Uri key, GithubHeaders value) async {
    await _store.record(key.toString()).put(
          _db.instance,
          value.toJson(),
        );
  }

  Future<GithubHeaders?> read(Uri key) async {
    final value = await _store.record(key.toString()).get(_db.instance);
    return value == null ? null : GithubHeaders.fromJson(value);
  }

  Future<void> delete(Uri key) async {
    await _store.record(key.toString()).delete(_db.instance);
  }
}
