import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini/CryptVault.dart';

class EditCredential extends StatefulWidget {
  final String itemId;
  final String currentAccount;
  final String currentPassword;

  EditCredential({
    required this.itemId,
    required this.currentAccount,
    required this.currentPassword,
  });

  @override
  _EditCredentialState createState() => _EditCredentialState();
}

class _EditCredentialState extends State<EditCredential> {
  late TextEditingController _accountController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: widget.currentAccount);
    _passwordController = TextEditingController(text: widget.currentPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Credential'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _accountController,
              decoration: InputDecoration(labelText: 'Account'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: OutlinedButton(
                  onPressed: () async {
                    String updatedAccount = _accountController.text;
                    String updatedPassword = _passwordController.text;

                    // Update the Firestore document
                    try {
                      await FirebaseFirestore.instance
                          .collection('vault')
                          .doc(widget.itemId)
                          .update({
                        'account': updatedAccount,
                        'password': updatedPassword,
                      });
                      // Create a map with the updated data
                      Map<String, String> updatedData = {
                        'account': updatedAccount,
                        'password': updatedPassword,
                      };

                      // Pass the updated data back to the previous screen
                      Navigator.pop(context, updatedData);
                    } catch (e) {
                      print('Error updating document: $e');
                      // Handle error here
                    }
                  },
                  child: Text("Save Updates")),
            )
          ],
        ),
      ),
    );
  }
}
