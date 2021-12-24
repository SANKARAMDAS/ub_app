import 'package:flutter/material.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';

class StateProvider with ChangeNotifier {
  InputState? _currentState;

  StateProvider(initValue) {
    _currentState = initValue;
  }

  final _states = [
    InputState.NUMBER,
    InputState.VALIDATE,
    InputState.CVV,
    InputState.NAME,
    InputState.DONE
  ];

  void moveNextState() {
    if (_currentState!.index < _states.length - 1) {
      print('Current State: ' + _currentState.toString());
      _currentState = _states[_currentState!.index + 1];
      print('After moveNextState: ' + _currentState.toString());
      notifyListeners();
    }
  }

  void moveFirstState() {
    _currentState = _states[0];
    notifyListeners();
  }

  void movePrevState() {
    if (_currentState!.index > 0) {
      _currentState = _states[_currentState!.index - 1];
      notifyListeners();
    }
  }

  InputState? getCurrentState() {
    return _currentState;
  }

  gotoState(InputState state) {
    _currentState = state;
    notifyListeners();
  }
}
