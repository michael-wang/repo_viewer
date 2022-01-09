import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';

import 'package:repo_viewer/auth/domain/auth_failure.dart';
import 'package:repo_viewer/auth/infra/credential_storage/credential_storage.dart';
import 'package:repo_viewer/core/infra/dio_extensions.dart';
import 'package:repo_viewer/core/shared/encoders.dart';

class GithubAuthenticator {
  final CredentialStorage _storage;
  final Dio _dio;

  GithubAuthenticator(this._storage, this._dio);

  static final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectURL = Uri.parse('http://localhost:3000/callback');
  static final revokationEndpoint =
      Uri.parse('https://api.github.com/applications/$clientID/token');

  static const clientID = '54caddbbacc2721400f5';
  static const clientSecret = '793a28ccf72753ac9866abd37b477e705b67e9ae';
  static const scopes = ['read:user', 'repo'];

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final creds = await _storage.read();
      if (creds != null) {
        if (creds.isExpired && creds.canRefresh) {
          // Not necessary for Github, but still implement the code for demo.
          // See: https://docs.github.com/en/developers/apps/building-github-apps/refreshing-user-to-server-access-tokens
          final failureOrCredentials = await refresh(creds);
          return failureOrCredentials.fold((l) => null, (r) => r);
        }
      }

      return creds;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() async {
    final cred = await getSignedInCredentials();
    return cred != null;
  }

  // AuthorizationCodeGrant is a class from oauth2 package which helps:
  // 1. Gather parameters (client id, secret, authorization url...).
  // 2. Construct full URL to auth server (with proper query parameters).
  // 3. Handle response from auth server (e.g. exchange auth code for access
  //    token).
  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
      clientID,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
      httpClient: _GithubOAuthHttpClient(),
    );
  }

  Uri getAuthURL(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectURL, scopes: scopes);
  }

  Future<Either<AuthFailure, Unit>> handleAuthResponse(
      AuthorizationCodeGrant grant, Map<String, String> queryParams) async {
    try {
      // Following function will failed because Github auth server's default
      // response is an URL encoded string:
      // 'access_token=xxx&scope=repo%2Cgist&token_type=bearer'
      // But oauth2 package expects response in JSON format:
      // {
      //   "access_token":"gho_16C7e42F292c6912E7710c838347Ae178B4a",
      //   "scope":"repo,gist",
      //   "token_type":"bearer"
      // }
      // Github doc says it will send response in JSON format if we ask for it
      // with header: 'Accept: application/json'.
      // So the solution is to write our own http client, appends proper header
      // before sending request to Github auth server.
      // Then we provide this extended http client when creating
      // AuthorizationCodeGrant.
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      await _storage.save(httpClient.credentials);
      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    final creds = await _storage.read();
    if (creds == null) {
      return left(const AuthFailure.storage());
    }
    final accessToken = creds.accessToken;
    // Basic authentication required when revoking access token, see:
    // https://docs.github.com/en/rest/overview/other-authentication-methods#basic-authentication
    final nameAndPassword = stringToBase64.encode('$clientID:$clientSecret');

    try {
      try {
        _dio.deleteUri(
          revokationEndpoint,
          data: {
            'access_token': accessToken,
          },
          options: Options(
            headers: {
              'Authorization': 'basic $nameAndPassword',
            },
          ),
        );
      } on DioError catch (e) {
        if (e.isNoConnection) {
          // Eat the exception so we can clear storage even when no internet
          // connection. The other option is NOT allow sign out when no
          // connection, which is a secure hole and not accepted.
        } else {
          // For other unexpected exception, rethrow so other caller in the call
          //  stack has chance to catch the exception. In this case storage is
          // not cleared because the un-expected exception happened.
          rethrow;
        }
      }
      _storage.clear();
      return right(unit);
    } catch (e) {
      return left(const AuthFailure.storage());
    }
  }

  // Assume called when old.canRefresh is true, so we don't need to catch
  // StateError when calling refresh.
  Future<Either<AuthFailure, Credentials>> refresh(Credentials old) async {
    try {
      final refreshed = await old.refresh(
        identifier: clientID,
        secret: clientSecret,
        httpClient: _GithubOAuthHttpClient(),
      );
      await _storage.save(refreshed);
      return right(refreshed);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}

class _GithubOAuthHttpClient extends http.BaseClient {
  final httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // We want Github auth server to response in JSON format, by adding 'Accept'
    // header. See: https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#response
    request.headers['Accept'] = 'application/json';
    return httpClient.send(request);
  }
}
