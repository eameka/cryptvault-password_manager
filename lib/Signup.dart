import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini/Login.dart';
import 'package:mini/dashscreen.dart';

class MySignup extends StatefulWidget{
  const MySignup({Key? key}) : super(key: key);

  @override

  _MySignupState createState() => _MySignupState();
}

class _MySignupState extends State<MySignup>{
  final usernamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage
          (image: AssetImage('assets/vault.jpg'), fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text('CryptVault', style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 33
              ),),
            ),
            SingleChildScrollView(
           child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.5, right: 35, left: 35),
              child:  Column(
                children: [
                  TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'E-mail',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Register', style: TextStyle(color: Colors.blueAccent, fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: (){
                            final user = User(
                              name: usernamecontroller.text,
                              email: emailcontroller.text,
                            );
                            createUser(user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Dashscreen()),
                            );
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
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, 'Login');
                      }, child: const Text('Login', style: TextStyle(decoration: TextDecoration.underline, fontSize: 20, color: Colors.blueAccent),))
                    ],
                  ),

                ],
              ),
            )
            ),
          ],
        ),
      ),
    );
  }

}

Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}

class User {
  String id;
  final String name;
  final String email;

  User({
    this.id = '',
    required this.email,
    required this.name,
});

  Map<String, dynamic> toJson() => {
    'id':id,
    'name': name,
    'email':email,
  };
}