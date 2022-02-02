import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  late Database _db;
  Database get instance => _db;

  bool _inited = false;

  Future<void> init() async {
    if (_inited) {
      return;
    }
    _inited = true;

    final dbDir = await getApplicationDocumentsDirectory();
    if (!dbDir.existsSync()) {
      dbDir.createSync(recursive: true);
    }
    final dbPath = join(dbDir.path, 'db.sembast');
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }
}
