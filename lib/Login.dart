import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mini/CryptVault.dart';
import 'dashscreen.dart';
import 'Logfile.dart';

class AuthenticateButton extends StatefulWidget {
  const AuthenticateButton({super.key});

  @override
  State<AuthenticateButton> createState() => _AuthenticateButtonState();
}

class _AuthenticateButtonState extends State<AuthenticateButton> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  late final LocalAuthentication auth;
  bool showBiometrics = false;
  bool authenticated = false;
  bool _supportState = false;
  @override
  void initState() {
    super.initState();
    fetchVaultItemsForUser();
    isBiometricAvailable();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  isBiometricAvailable() async {
    showBiometrics = await LocalAuth.getAvailableBiometrics();
    setState(() {});
  }

  bool isLoading = true; // Initially set to true for loading
  List<VaultItem> vaultItems = [];

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
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('CryptVault'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 40),
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
                              builder: (context) =>
                                  CryptVault(source: 'login_screen'),
                            ),
                          );
                        },
                        child: Text("View credentials in Vault")),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const MyCustomForm()),
                  //     );
                  //   },
                  //   child: const Text('+ Add a credential'),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () async {
                  await LocalAuth.getAvailableBiometrics();
                },
                child: const Text('Check available biometrics')),
            ElevatedButton(
              onPressed: () async {
                final authenticate = await LocalAuth.hasBiometrics();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Availability'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              buildText('Biometric', authenticate),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Ok'),
                            )
                          ],
                        ));
              },
              child: const Text('Check Biometric Availability'),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                final authenticated = await LocalAuth.authenticate();
                if (authenticated) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Dashscreen()),
                  );
                }
              },
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildText(String text, bool checked) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          checked
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 24),
          )
        ],
      ),
    );
