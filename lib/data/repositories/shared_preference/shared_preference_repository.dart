import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferenceRepository {
  Future<bool> getValue(String key);

  Future<void> setValue(String key, bool value);
}

class FirstTimeRepositoryTmpl implements SharedPreferenceRepository {
  FirstTimeRepositoryTmpl() {
    _init();
  }

  late SharedPreferences _preferences;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      _preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _init();
    }
  }

  @override
  Future<bool> getValue(String key) async {
    await _ensureInitialized();
    return _preferences.getBool(key) ?? false;
  }

  @override
  Future<void> setValue(String key, bool value) async {
    await _ensureInitialized();
    await _preferences.setBool(key, value);
  }
}
