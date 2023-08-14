import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      debugShowCheckedModeBanner: false,
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
        title: const Text('CryptVault Dashboard'),
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

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool isLoading = true; // Initially set to true for loading
  List<VaultItem> vaultItems = [];
  @override
  void initState() {
    super.initState();
    fetchVaultItemsForUser();
  }

  fetchVaultItemsForUser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user == null) {
        return []; // Return an empty list if no user is logged in
      }

      String userEmail = user.email ?? ''; // Get the user's email

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vault')
          .where('user', isEqualTo: userEmail)
          .get();

      querySnapshot.docs.forEach((doc) {
        print(doc);
        vaultItems.add(VaultItem(
          id: doc.id,
          account: doc['account'],
          password: doc['password'],
          user: doc['user'],
        ));
      });

      setState(() {
        isLoading = false;
      });
      return vaultItems;
    } catch (e) {
      print('Error fetching vault items: $e');
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height *
              0.3, // 40% of the screen's height
          width: MediaQuery.of(context).size.width *
              0.7, // 70% of the screen's width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You have"),
              isLoading
                  ? const CupertinoActivityIndicator(
                      radius: 35,
                      color: Colors.blue,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        vaultItems.length.toString(),
                        style: const TextStyle(color: Colors.blue, fontSize: 40),
                      ),
                    ),
              const Text("credentials in your vault."),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CryptVault(),
                        ),
                      );
                    },
                    child: Text("View credentials in Vault")),
              )
            ],
          ),
        ),
        SizedBox(
          height: 100,
        ),
        ElevatedButton(
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCustomForm()),
            );
          },
          child: const Text('+ Add a credential'),
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
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const CupertinoAlertDialog(
                      title: Text("Adding Credential"),
                      content: Column(
                        children: [
                          CupertinoActivityIndicator(),
                          SizedBox(height: 16),
                          Text("Please wait..."),
                        ],
                      ),
                    );
                  },
                );
                addCredential(_accountController.text, _passController.text)
                    .then((value) => {
                          Navigator.pop(context),
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text("Success"),
                                content: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        CupertinoIcons.check_mark_circled,
                                        size: 45,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                        "Credential added to the vault successfully"),
                                  ],
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CryptVault(),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                          print(value.message),
                        });
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) {
                //     return CryptVault(
                //       accountController: _accountController.text,
                //       passController: _passController.text,
                //     );
                //   }),
                // );
              },
              child: Text(
                'Add Credentials'.toUpperCase(),
                style: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Future createVault(Vault vault) async {
//   final docVault = FirebaseFirestore.instance.collection('vault').doc();
//   vault.id = docVault.id;

//   final json = vault.toJson();
//   await docVault.set(json);
// }
Future<InsertResponse> addCredential(String account, String password) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return InsertResponse(success: false, message: 'No user logged in.');
    }

    String userEmail = user.email ?? ''; // Get the user's email

    await FirebaseFirestore.instance
        .collection('vault')
        .add({'account': account, 'password': password, "user": userEmail});

    return InsertResponse(
        success: true, message: 'Data inserted successfully.');
  } catch (e) {
    return InsertResponse(success: false, message: 'Error inserting data: $e');
  }
}

class InsertResponse {
  final bool success;
  final String message;

  InsertResponse({required this.success, required this.message});
}

class VaultItem {
  final String id;
  final String account;
  final String password;
  final String user;

  VaultItem({
    required this.id,
    required this.account,
    required this.password,
    required this.user,
  });
}

// class Vault {
//   String id;
//   final String account;
//   final String password;

//   Vault({
//     this.id = '',
//     required this.account,
//     required this.password,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'Account': account,
//         'Password': password,
//       };
// }
