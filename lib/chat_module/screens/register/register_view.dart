import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/register/register_controller.dart';
import '../../widgets/my_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController _registerController;

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _registerController.streamController.stream as Stream<Object>?,
        builder: (context, snapshot) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(0),
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Text(
                            'Cadastro',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Crie uma conta no SecretChatApp.',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _registerController.nameController,
                            decoration:
                                InputDecoration(labelText: 'Nome completo'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _registerController.usernameController,
                            decoration:
                                InputDecoration(labelText: 'Nome de usuario'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _registerController.passwordController,
                            decoration: InputDecoration(labelText: 'Senha'),
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          MyButton(
                            title: _registerController.formSubmitting
                                ? 'CRIANDO...'
                                : 'CRIAR CONTA',
                            onTap: _registerController.submitForm,
                            disabled: !_registerController.isFormValid ||
                                _registerController.formSubmitting,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
