import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/core/shared/globals.dart';

part 'github_headers.freezed.dart';
part 'github_headers.g.dart';

@freezed
class GithubHeaders with _$GithubHeaders {
  const GithubHeaders._();
  const factory GithubHeaders({
    String? eTag,
    PaginationLink? link,
  }) = _GithubHeaders;

  factory GithubHeaders.parse(Response r) {
    final h = r.headers.map;
    final linkHeader = h['Link']?[0];
    return GithubHeaders(
      eTag: h['ETag']?[0],
      link: linkHeader == null
          ? null
          : PaginationLink.build(
              linkHeader,
              reqURL: r.requestOptions.uri.toString(),
            ),
    );
  }

  factory GithubHeaders.fromJson(Map<String, dynamic> json) =>
      _$GithubHeadersFromJson(json);
}

/* A class to hide how to parse link header, e.g.:
  <https://api.github.com/user/starred?sort=stars&order=desc&page=1>; rel="prev",
  <https://api.github.com/user/starred?sort=stars&order=desc&page=3>; rel="next",
  <https://api.github.com/user/starred?sort=stars&order=desc&page=3>; rel="last",
  <https://api.github.com/user/starred?sort=stars&order=desc&page=1>; rel="first"

  for requst url:
  https://api.github.com/user/starred?sort=stars&order=desc&page=2
*/
@freezed
class PaginationLink with _$PaginationLink {
  const PaginationLink._();
  const factory PaginationLink({
    required int maxPage,
  }) = _PaginationLink;

  factory PaginationLink.build(
    String linkHeader, {
    required String reqURL,
  }) {
    log.d(linkHeader);
    return PaginationLink(
      maxPage: _extractPage(
        _extractURL(
          _getLastLink(
            linkHeader.split(','),
            reqURL,
          ),
        ),
      ),
    );
  }

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);

  // Get string contains 'rel="last"', or if not found, return request URL which
  // happens when we are query last page.
  static String _getLastLink(List<String> pageLinks, String reqURL) {
    return pageLinks.firstWhere(
      (e) => e.contains('rel="last"'),
      orElse: () => reqURL,
    );
  }

  // From: '<https://api.github.com/user/starred?sort=stars&order=desc&page=3>; rel="last"'
  // to:   'https://api.github.com/user/starred?sort=stars&order=desc&page=3'
  static String _extractURL(String v) {
    return RegExp(
                r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)')
            .stringMatch(v) ??
        '';
  }

  // url: <https://api.github.com/user/starred?sort=stars&order=desc&page=3>; rel="last"
  static int _extractPage(String url) {
    final lastPageUri = Uri.parse(url).queryParameters['page'] ?? '';
    final r = int.tryParse(lastPageUri);
    if (r == null) {
      return 0;
    }
    return r;
  }
}
