import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:flutter/material.dart';

class LocalAuth{
  static final _auth = LocalAuthentication();

   static Future<bool> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    print('List of availableBiometrics: $availableBiometrics');
    if(availableBiometrics.isNotEmpty) {
      return true;
    }
    return false;
  }



  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    }on PlatformException catch (e){
      return false;
    }
  }



  static Future<bool> authenticate() async {
   // final isAvailable = await hasBiometrics();
   // if (!isAvailable) return false;

    try{

      final bool didAuthenticate =
       await _auth.authenticate(
        authMessages: const[
          AndroidAuthMessages(
            signInTitle: 'Authentication',
            cancelButton: 'No thanks',
          ),

          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        localizedReason: 'Use Face ID to authenticate',
          options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
          ),
      );
      return didAuthenticate;
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}

