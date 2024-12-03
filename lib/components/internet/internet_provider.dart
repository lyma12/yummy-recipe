import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InternetConnectViewModel extends StateNotifier<bool> {
  InternetConnectViewModel(this.ref) : super(false) {
    _checkInternetConnection();
  }

  final Ref ref;

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    state = !connectivityResult.contains(ConnectivityResult.none);
  }

  void startListeningToConnectivity() {
    Connectivity().onConnectivityChanged.listen(
      (result) {
        state = !result.contains(ConnectivityResult.none);
      },
    );
  }
}

final internetProvider = StateNotifierProvider<InternetConnectViewModel, bool>(
  (ref) {
    final viewModel = InternetConnectViewModel(ref);
    viewModel.startListeningToConnectivity();
    return viewModel;
  },
);
