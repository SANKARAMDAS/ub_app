import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('bloc: ${bloc.runtimeType} Created');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('bloc: ${bloc.runtimeType}, error: $error');
    recordError(error, stackTrace);
  }
}
