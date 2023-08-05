import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini/Signup.dart';

class MySplash extends StatefulWidget{
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MySignup(),));
    });
  }

  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: SweepGradient(colors: [Colors.blueAccent, Colors.black12,Colors.black38],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security_sharp, size: 80, color:Colors.blueGrey,),
            SizedBox(height:20 ,),
            Text('CryptVault', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey, fontSize: 32,),),
            Text('shield your info', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: 20,),),
          ],
        ),
      ),
    );
  }
}