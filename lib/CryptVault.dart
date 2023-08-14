import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini/EditCredential.dart';
import 'package:mini/dashscreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CryptVault extends StatefulWidget {
  const CryptVault({Key? key}) : super(key: key);

  @override
  _CryptVaultState createState() => _CryptVaultState();
}

class _CryptVaultState extends State<CryptVault> {
  List<VaultItem> vaultItems = [];
  bool isLoading = true; // Initially set to true for loading

  @override
  void initState() {
    super.initState();
    fetchVaultItems();
  }

  Future<void> fetchVaultItems() async {
    List<VaultItem> items = await fetchVaultItemsForUser();
    setState(() {
      vaultItems = items;
      isLoading = false; // Set to false after loading
    });
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

      return vaultItems;
    } catch (e) {
      print('Error fetching vault items: $e');
      return []; // Return an empty list on error
    }
  }

  bool isDeleting = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Credentials'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashscreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isDeleting,
        progressIndicator: CupertinoActivityIndicator(
          radius: 30,
        ),
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CupertinoActivityIndicator(
                      radius: 30,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Loading credentials")
                ],
              )
            : vaultItems.length < 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Center(child: Text("No credentials added"))],
                  )
                : ListView.builder(
                    itemCount: vaultItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.safety_check,
                          color: Colors.blue,
                          size: 35,
                        ),
                        title: Text(vaultItems[index].account),
                        subtitle: Text(vaultItems[index].password),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () async {
                                    Map<String, String>? updatedData =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCredential(
                                            itemId: vaultItems[index].id,
                                            currentAccount:
                                                vaultItems[index].account,
                                            currentPassword:
                                                vaultItems[index].password),
                                      ),
                                    );
                                    // If updatedData is not null (i.e., changes were made), update vaultItems
                                    if (updatedData != null) {
                                      setState(() {
                                        vaultItems[index].account =
                                            updatedData['account']!;
                                        vaultItems[index].password =
                                            updatedData['password']!;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isDeleting = true;
                                    });

                                    final docVault = FirebaseFirestore.instance
                                        .collection('vault')
                                        .doc(vaultItems[index].id);
                                    docVault.delete();
                                    setState(() {
                                      vaultItems.removeAt(index);
                                      isDeleting = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      // body: Container(
      //   padding: const EdgeInsets.all(8),
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         leading: const Icon(Icons.safety_check),
      //         title: Column(
      //           children: [],
      //         ),
      //         trailing: SizedBox(
      //           width: 100,
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: IconButton(
      //                   onPressed: () {},
      //                   icon: const Icon(Icons.edit),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: IconButton(
      //                   onPressed: () {
      //                     final docVault = FirebaseFirestore.instance
      //                         .collection('vault')
      //                         .doc();

      //                     docVault.delete();
      //                   },
      //                   icon: const Icon(
      //                     Icons.delete_outlined,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

class VaultItem {
  final String id;
  late String account;
  late String password;
  final String user;

  VaultItem({
    required this.id,
    required this.account,
    required this.password,
    required this.user,
  });
}
