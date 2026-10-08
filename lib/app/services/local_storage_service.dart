import 'package:hive/hive.dart';

class LocalStorageService {
  final Box<String> _box;

  LocalStorageService(this._box);

  String? read(String key) => _box.get(key);

  Future<void> write(String key, String value) => _box.put(key, value);

  Future<void> delete(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();
}
