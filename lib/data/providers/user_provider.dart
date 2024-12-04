import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/utilities/constants/firebase_user_profile_field_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final userProfileProvider = Provider<UserProfileRepository>(
  (ref) => UserFirebaseStoreRepositoryImpl(
    FirebaseFirestore.instance
        .collection(FirebaseUserProfileFieldName.user)
        .withConverter<UserFirebaseProfile>(
          fromFirestore: (snapshot, _) =>
              UserFirebaseProfile.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        ),
  ),
);
