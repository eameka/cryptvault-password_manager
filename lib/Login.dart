import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dashscreen.dart';
import 'Logfile.dart';


class AuthenticateButton extends StatefulWidget{
  const AuthenticateButton({super.key});

  @override
  State<AuthenticateButton> createState() => _AuthenticateButtonState();

}

class _AuthenticateButtonState extends State<AuthenticateButton>{
  late final LocalAuthentication auth;
  bool showBiometrics = false;
  bool authenticated =false;
  bool _supportState = false;
  @override
  void initState() {
    super.initState();
    isBiometricAvailable();
    auth =LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState((){
      _supportState = isSupported;
    }),);
  }

  isBiometricAvailable() async {
    showBiometrics = await LocalAuth.getAvailableBiometrics();
    setState(() { });
  }


  @override
  Widget build(BuildContext context){

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
            ElevatedButton(onPressed: () async {
              await LocalAuth.getAvailableBiometrics();},
                child: const Text('Check available biometrics')),
            ElevatedButton(onPressed: () async{
             final authenticate = await LocalAuth.hasBiometrics();
             showDialog(context:context,
                 builder: (context) => AlertDialog(
                   title: const Text('Availability'),
                   content: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       const SizedBox(height: 16,),
                       buildText('Biometric',authenticate),
                     ],
                   ),
                   actions: [
                     ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'),)
                   ],
                 ));
            },
              child:
                    const Text('Check Biometric Availability'),
           ),
            const SizedBox(height:40 ,),
            ElevatedButton(
              onPressed: () async{
                final authenticated = await LocalAuth.authenticate();
                   if (authenticated){
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
  margin: const EdgeInsets.symmetric(vertical:8),
  child: Row(
    children: [
      checked
      ? const Icon(Icons.check, color: Colors.green,)
      : const Icon(Icons.close, color: Colors.red,),
      const SizedBox(width:12),
      Text(text, style: const TextStyle(fontSize: 24),)
    ],
  ),
);









