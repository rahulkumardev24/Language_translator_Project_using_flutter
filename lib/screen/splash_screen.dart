import 'package:flutter/material.dart';
import 'package:translater_new/screen/translator_screen.dart';
import 'dart:async';

import 'package:translater_new/utils/custom_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LanguageTranslatorScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset(
                  "assets/images/trans.png",
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      "Language Translator",
                      style: myTextStyle24(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Dictionary | Antonyms & Synonyms | 16 Languages",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontFamily: "main",
                          color: Colors.black45),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
