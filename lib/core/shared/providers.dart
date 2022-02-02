import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/core/infra/sembast_database.dart';

final sembastProvider = Provider((ref) => SembastDatabase());
