import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveStorageProvider = Provider<HiveStorage>(
  (ref) => HiveStorage(),
);
