import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facebookSigninRepositoryProvider = Provider<SignInRepository>(
  (ref) => FacebookRepositoryImpl(),
);
final googleSigninRepositoryProvider = Provider<SignInRepository>(
  (ref) => GoogleRepositoryImpl(),
);
final firebaseAuthRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);
