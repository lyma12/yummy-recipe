import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/models/user/user_firebase_profile.dart';
import 'firebase_user_profile_field_name.dart';

class AppOptions {
  AppOptions._();

  static Dio get dioAPI {
    final dio = Dio();
    dio.options = BaseOptions(
      queryParameters: {
        'apiKey': "e300d27d81ce4f9294e6c43f9ef190b9",
        //"38aa86772f764ce2ad703b4a48293a79", //"e300d27d81ce4f9294e6c43f9ef190b9", //"81081583d99746399431c09f9dd607a0", //"ac91110f50624fdfa79754f0291a8d89",
      },
    );
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 99,
        ),
      );
    }
    return dio;
  }

  static CollectionReference get userProviderDocumentReference =>
      FirebaseFirestore.instance
          .collection(FirebaseUserProfileFieldName.user)
          .withConverter<UserFirebaseProfile>(
            fromFirestore: (snapshot, _) =>
                UserFirebaseProfile.fromJson(snapshot.data() ?? {}),
            toFirestore: (user, _) => user.toJson(),
          );
}
