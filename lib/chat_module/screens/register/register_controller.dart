// import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/custom_error.dart';
import '../../data/models/user.dart';
import '../../data/repositories/register_repository.dart';
import '../../screens/home/home_view.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/state_control.dart';

class RegisterController extends StateControl {
  final BuildContext context;

  RegisterRepository _registerRepository = RegisterRepository();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isFormValid = false;

  get isFormValid => _isFormValid;

  bool _formSubmitting = false;

  get formSubmitting => _formSubmitting;

  RegisterController({
    required this.context,
  }) {
    this.init();
  }

  void init() {
    this.nameController.addListener(this.validateForm);
    this.usernameController.addListener(this.validateForm);
    this.passwordController.addListener(this.validateForm);
  }

  void validateForm() {
    bool isFormValid = _isFormValid;
    String name = this.nameController.value.text;
    String username = this.usernameController.value.text;
    String password = this.passwordController.value.text;
    if (name.trim() == "" || username.trim() == "" || password.trim() == "") {
      isFormValid = false;
    } else {
      isFormValid = true;
    }
    _isFormValid = isFormValid;
    notifyListeners();
  }

  void submitForm() async {
    _formSubmitting = true;
    notifyListeners();
    String name = this.nameController.value.text;
    String username = this.usernameController.value.text;
    // String password = this.passwordController.value.text;
    var loginResponse = await _registerRepository.register(name, username ,context);
    if (loginResponse is CustomError) {
      showAlertDialog(loginResponse.errorMessage);
    } else if (loginResponse is User) {
      await CustomSharedPreferences.setString('user', loginResponse.toString());
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen_new.routeName, (_) => false);
    }
    _formSubmitting = false;
    notifyListeners();
  }

  showAlertDialog(String message) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Verifique os erros"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
