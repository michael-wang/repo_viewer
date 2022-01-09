import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' show Credentials;
import 'package:repo_viewer/auth/infra/credential_storage/credential_storage.dart';

class SecureCredentialStorage implements CredentialStorage {
  final FlutterSecureStorage _storage;

  SecureCredentialStorage(this._storage);

  static const _key = 'oauth2_credentials';

  Credentials? _cachedCredentials;

  @override
  Future<Credentials?> read() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }

    final json = await _storage.read(key: _key);
    if (json == null) {
      return null;
    }

    try {
      _cachedCredentials = Credentials.fromJson(json);
      return _cachedCredentials;
    } on FormatException {
      clear();
      return null;
    }
  }

  @override
  Future<void> save(Credentials creds) async {
    _cachedCredentials = creds;
    return await _storage.write(key: _key, value: creds.toJson());
  }

  @override
  Future<void> clear() async {
    _cachedCredentials = null;
    _storage.delete(key: _key);
    return;
  }
}
