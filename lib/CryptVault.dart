import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CryptVault extends StatelessWidget {
   CryptVault({Key? key, required this.accountController, required this.passController}) :super(key: key);


   String accountController;
   String passController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
        appBar: AppBar(
          title: const Text('CryptVault'),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon: const Icon(Icons.arrow_back_ios_new),),
          backgroundColor: Colors.blueAccent,
        ),

      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.safety_check),
              title: Column(
                children:[
                Text(accountController),
                Text(passController),
                ],
              ),
              trailing: SizedBox(
                width: 40,
                child: Row(
                  children: [
                    Expanded(child:IconButton(onPressed: (){


                    }, icon: const Icon(Icons.edit))),
                    Expanded(child:IconButton(onPressed: (){

                        final docVault = FirebaseFirestore.instance.collection('vault').doc();

                        docVault.delete();

                    }, icon: const Icon(Icons.delete_outlined))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



