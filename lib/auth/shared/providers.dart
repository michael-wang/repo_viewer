import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:repo_viewer/auth/application/auth_notifier.dart';
import 'package:riverpod/riverpod.dart';

import 'package:repo_viewer/auth/infra/credential_storage/credential_storage.dart';
import 'package:repo_viewer/auth/infra/credential_storage/secure_credential_storage.dart';
import 'package:repo_viewer/auth/infra/github_authenticator.dart';

final flutterSecureStorageProvider =
    Provider((ref) => const FlutterSecureStorage());
final credentialStorageProvider = Provider<CredentialStorage>(
    (ref) => SecureCredentialStorage(ref.watch(flutterSecureStorageProvider)));

final dioProvider = Provider((ref) => Dio());

final githubAuthenticatorProvider = Provider(
  (ref) => GithubAuthenticator(
    ref.watch(credentialStorageProvider),
    ref.watch(dioProvider),
  ),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(githubAuthenticatorProvider)),
);
