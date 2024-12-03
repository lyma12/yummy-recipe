import 'package:base_code_template_flutter/data/repositories/firebase/firebase_storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider = Provider<FirebaseStorageRepository>(
    (ref) => FirebaseStorageRepositoryImpl(FirebaseStorage.instance.ref()));
