import 'package:flutter/foundation.dart';

class GenericChangeNotifier<T> extends ChangeNotifier {
  T _value;

  T get value => _value;

  GenericChangeNotifier({required T value}) : _value = value;

  void set(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
