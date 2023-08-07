import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CryptVault.dart';

void main() {
  runApp(const Dashscreen());
}

class Dashscreen extends StatelessWidget {
  const Dashscreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptVault',
      theme: ThemeData(),
      home: const MyVault(),
    );
  }
}

class MyVault extends StatelessWidget {
  const MyVault({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CryptVault'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[850],
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AddButton(),
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ElevatedButton(
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCustomForm()),
            );
          },
          child: const Text('+'),
        ),
      ]),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 50.0,
      ),
      key: _formKey,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Center(
                child: Text(
                  'Add New Credentials to Vault',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(
                  labelText: 'Account/Website name',
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.security_sharp),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                style:
                    OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () {
                  final vault = Vault(
                    account: _accountController.text,
                    password: _passController.text,
                  );
                  createVault(vault);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CryptVault(
                        accountController: _accountController.text,
                        passController: _passController.text,
                      );
                    }),
                  );
                },
                child: Text(
                  'Add Credentials'.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}

Future createVault(Vault vault) async {
  final docVault = FirebaseFirestore.instance.collection('vault').doc();
  vault.id = docVault.id;

  final json = vault.toJson();
  await docVault.set(json);
}

class Vault {
  String id;
  final String account;
  final String password;

  Vault({
    this.id = '',
    required this.account,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Account': account,
        'Password': password,
      };
}
