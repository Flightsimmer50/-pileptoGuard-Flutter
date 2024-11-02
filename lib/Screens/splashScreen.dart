import 'package:epilepto_guard/Screens/Crise/historiqueCrise.dart';
import 'package:epilepto_guard/Screens/Crise/postCriseFormulaire.dart';
import 'package:epilepto_guard/Screens/User/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Doctor/patientsList.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        // builder: (context) => PostCriseFormulaire(),
        builder: (context) => LoginScreen(),
        // builder: (context)=> CrisisHistoryScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/background/splash_screen.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset('assets/images/logo/epilepto_guard.png'),
          ),
        ],
      ),
    );
  }
}