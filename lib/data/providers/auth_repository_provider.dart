import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facebookSigninRepositoryProvider = Provider<SigninRepository>(
  (ref) => FacebookRepositoryImpl(),
);
final googleSigninRepositoryProvider = Provider<SigninRepository>(
  (ref) => GoogleRepositoryImpl(),
);
final firebaseAuthRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);
