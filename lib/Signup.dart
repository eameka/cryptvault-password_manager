import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini/Login.dart';
import 'package:mini/dashscreen.dart';

class MySignup extends StatefulWidget {
  const MySignup({Key? key}) : super(key: key);

  @override
  _MySignupState createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  final usernamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/vault.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'CryptVault',
                style: TextStyle(color: Colors.blueAccent, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  // TextField(
                  //   controller: usernamecontroller,
                  //   decoration: InputDecoration(
                  //     fillColor: Colors.white,
                  //     filled: true,
                  //     hintText: 'Username',
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(25))),
                  // ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            // final user = User(
                            //   name: usernamecontroller.text,
                            //   email: emailcontroller.text,
                            // );
                            if (emailcontroller.text == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text(
                                          "Email field cannot be empty"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showSignUpDialog(
                                  context); // Show the Cupertino-style alert dialog with activity indicator
                              signUpWithEmail(emailcontroller.text,
                                      emailcontroller.text)
                                  .then((value) => {
                                        Navigator.pop(
                                            context), // Close the dialog
                                        print(
                                            "value==================================== $value"),
                                        if (value.toString() ==
                                            "[firebase_auth/email-already-in-use] The email address is already in use by another account.")
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (builder) {
                                                return CupertinoAlertDialog(
                                                  title: const Text("Alert"),
                                                  content: const Text(
                                                      "The email address is already in use by another account."),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            )
                                          }
                                        else
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (builder) {
                                                return CupertinoAlertDialog(
                                                  title: const Text("Success"),
                                                  content: const Text(
                                                      "You have signed up successfully!"),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text("Ok"),
                                                      onPressed: () {
                                                        // To disable the user from going back to the signup screen
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Dashscreen(),
                                                          ),
                                                          (route) =>
                                                              false, // Remove all previous routes from the stack
                                                        );
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            )
                                          }
                                      });
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            if (emailcontroller.text == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text(
                                          "Email field cannot be empty"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showSignInDialog(
                                  context); // Show the Cupertino-style alert dialog with activity indicator
                              signInWithEmail(emailcontroller.text,
                                      emailcontroller.text)
                                  .then((value) => {
                                        Navigator.pop(
                                            context), // Close the dialog
                                        print(
                                            "value==================================== $value"),
                                        if (value.toString() ==
                                            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.")
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (builder) {
                                                return CupertinoAlertDialog(
                                                  title: const Text("Alert"),
                                                  content: const Text(
                                                      "Email account not registered."),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            )
                                          }
                                        else
                                          {
                                            Navigator.pushNamed(
                                                context, 'Login')
                                          }
                                      });
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 20,
                                color: Colors.blueAccent),
                          ))
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// Future createUser(User user) async {
//   final docUser = FirebaseFirestore.instance.collection('users').doc();
//   user.id = docUser.id;

//   final json = user.toJson();
//   await docUser.set(json);
// }

// class User {
//   String id;
//   final String name;
//   final String email;

//   User({
//     this.id = '',
//     required this.email,
//     required this.name,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'email': email,
//       };
// }

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<Object?> signUpWithEmail(String email, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
    // print("User created successfully.");
    // // Add user email to Firestore collection
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
    });
    return credential.user;
  } catch (e) {
    print("Error creating user: $e");
    return e;
  }
}

Future<Object?> signInWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  } catch (e) {
    print("Error creating user: $e");
    return e;
  }
}

void showSignUpDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const CupertinoAlertDialog(
        title: Text("Signing Up"),
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
}

void showSignInDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const CupertinoAlertDialog(
        title: Text("Signing In"),
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
}
