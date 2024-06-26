import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class LanguageTranslatorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageTranslatorScreenPage();
}

class _LanguageTranslatorScreenPage extends State<LanguageTranslatorScreen> {
  var languageList = [
    "Hindi",
    "English",
    "Marathi",
    "Bengali",
    "Gujarati",
    "Russian",
    "Urdu",
    "Maithili",
    "Japanese",
    "Punjabi",
    "Kashmiri",
    "Sanskrit",
    "Odia",
    "Santali",
    "Nepali",
    "Telugu"
  ];
  var originLanguage = "English";
  var destinationLanguage = "Hindi";
  var outputLanguage = "";
  TextEditingController languageController = TextEditingController();

  // ...............SPEAK...............//
  final FlutterTts _flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool isButtonPressed = false;
  final String _selectedLanguage = 'en-US';

  @override
  void initState() {
    super.initState();
    initializedTts();  // here we call initializedTts
    initializedSpeechToText() ;
  }

  void initializedTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("TTS Error: $msg");
        isSpeaking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $msg")),
      );
    });

    // Optionally set default voice parameters
    _flutterTts.setLanguage(_selectedLanguage);
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      try {
        await _flutterTts.speak(text);
      } catch (e) {
        print("TTS Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to speak: $e")),
        );
      }
    }
  }

  //

  void translate(String source, String destination, String input) async {
    GoogleTranslator translator = GoogleTranslator();
    var translation =
        await translator.translate(input, from: source, to: destination);
    setState(() {
      outputLanguage = translation.text.toString();
    });

    if (source == "__" || destination == "__") {
      setState(() {
        outputLanguage = "Fail to Translate the language";
      });
    }
  }

  String languageCode(String language) {
    switch (language) {
      case "Hindi":
        return "hi";
      case "English":
        return "en";
      case "Marathi":
        return "mr";
      case "Bengali":
        return "bn";
      case "Gujarati":
        return "gu";
      case "Russian":
        return "ru";
      case "Urdu":
        return "ur";
      case "Maithili":
        return "mai";
      case "Japanese":
        return "ja";
      case "Punjabi":
        return "pa";
      case "Kashmiri":
        return "ks";
      case "Sanskrit":
        return "sa";
      case "Odia":
        return "or";
      case "Santali":
        return "sat";
      case "Nepali":
        return "ne";
      case "Telugu":
        return "te";
      default:
        return "__";
    }
  }

  // ................................VOICE RECOGNITION ........ SPEECH TO TEXT ......................... //

  bool startRecording = false;
  final SpeechToText speechToText = SpeechToText();
  bool isAvailable = false;

 //  this function is call above inside the  initState
 Future<void> initializedSpeechToText() async {
 isAvailable = await speechToText.initialize();
 setState(() {

 });
 }

  // ............IMAGE PICKER AND CAMERA , IMAGE TEXT INTO TEXT ...............//
  XFile? pickedImage ;
  String myText = "";
  bool scanning = false ;
  final ImagePicker imagePicker = ImagePicker() ;


  getImage(ImageSource ourSource) async {
    XFile? result = await imagePicker.pickImage(source: ourSource);
    if (result != null) {
      setState(() {
        pickedImage = result ;
      });
      performTextRecogintion();
    }
  }
  performTextRecogintion() async {
    setState(() {
      scanning = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        myText = recognizedText.text;
        languageController.text = recognizedText.text; // Update the languageController text
        scanning = false;
      });
      textRecognizer.close();
    } catch (e) {
      print("Error during text recognition $e");
      setState(() {
        scanning = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Translator"),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),

      // .......................Mic FloatingActionButton ....................//
      floatingActionButton: Container(
        width: double.infinity,
        // padding: EdgeInsets.symmetric(hori),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Gallery Button
            galleryButton(),
            // Here we call Floating Mic Button
            micButton() ,
            // here we call camera button
            cameraButton()

          ],
        ),
      ),

      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fromLanguageList(),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_right_alt_outlined,
                      color: Colors.black87,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    toLanguageList()
                  ],
                ),
                const SizedBox(height: 10),
                imagePickerContainer() ,
                userInputTextBox(),
                const SizedBox(height: 10),
                translatedButton(),
                const SizedBox(height: 10),
                outputTextBox(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  //........................................WIDGETS..........................//

  //.......................FROM LANGUAGE LIST BOX ....................................//


  Widget fromLanguageList() {
    return Container(
      height: 60,
      width: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 2, offset: Offset(1.0, 2.0))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: DropdownButton(
          focusColor: Colors.tealAccent,
          iconDisabledColor: Colors.blue.shade100,
          iconEnabledColor: Colors.blue.shade100,
          hint: Text(
            originLanguage,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 23,
                fontWeight: FontWeight.bold),
          ),
          dropdownColor: Colors.blue.shade50,
          items: languageList.map((String dropDownStringItem) {
            return DropdownMenuItem(
              child: Text(dropDownStringItem),
              value: dropDownStringItem,
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              originLanguage = value!;
            });
          },
        ),
      ),
    );
  }

  //..................... To LANGUAGE LIST BOX ...........................//
  Widget toLanguageList() {
    return Container(
      height: 60,
      width: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 2, offset: Offset(1.0, 2.0))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: DropdownButton(
          focusColor: Colors.tealAccent,
          iconDisabledColor: Colors.blue.shade100,
          iconEnabledColor: Colors.blue.shade100,
          alignment: Alignment.center,
          hint: Text(
            destinationLanguage,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdownColor: Colors.blue.shade50,
          items: languageList.map((String dropDownStringItem) {
            return DropdownMenuItem(
              child: Text(dropDownStringItem),
              value: dropDownStringItem,
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              destinationLanguage = value!;
            });
          },
        ),
      ),
    );
  }

  //......................... USER INPUT BOX ...........................//

  Widget userInputTextBox() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        autocorrect: true,
        maxLines: 5,
        cursorColor: Colors.deepOrange,
        autofocus: false,
        style: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 2, color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.tealAccent)),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(10)),
          hintText: "Write Text",
          labelStyle: TextStyle(fontSize: 20, color: Colors.deepOrange),
        ),
        controller: languageController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please Enter Text To Translate";
          }
          return null;
        },
      ),
    );
  }

  //....................TRANSLATED BUTTON ................................//

  Widget translatedButton() {
    return Container(
      width: 300,
      child: FloatingActionButton(
        onPressed: () {
          translate(
              languageCode(originLanguage),
              languageCode(destinationLanguage),
              languageController.text.toString());
        },
        backgroundColor: Colors.tealAccent.shade100,
        splashColor: Colors.orange.shade400,
        elevation: 5,
        hoverColor: Colors.teal,
        child: const Text(
          "Translate",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
        ),
      ),
    );
  }

  //...................OUTPUT TEXT BOX .....................................//

  Widget outputTextBox() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.deepOrange)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                speakIconButton(),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$outputLanguage",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold ,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ................. Speaker icon ...............................//

  Widget speakIconButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isButtonPressed = true;
        });
        _speak(outputLanguage);
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            isButtonPressed = false;
          });
        });
      },
      icon: Icon(Icons.volume_up_sharp),
      color: isButtonPressed ? Colors.orange : Colors.black,
    );
  }

  // ............................MIC FLOATING ACTION BUTTON ....................//
  Widget micButton() {
    return AvatarGlow(
      animate: startRecording,
      startDelay: Duration(milliseconds: 100),
      glowColor: Colors.blueAccent,
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            startRecording = true;
          });
          if (isAvailable) {
          speechToText.listen(
            onResult:(result){
              setState(() {
                languageController.text = result.recognizedWords;

              });
            }
          );

          }
        },
        onTapUp: (value) {
          setState(() {
            startRecording = false;
          });
         speechToText.stop();
        },
        onTapCancel: (){
          setState(() {
            startRecording = false ;
          });
          speechToText.stop();
        },
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Colors.black45 , blurRadius: 5)]
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.tealAccent,
              padding: EdgeInsets.all(0), // Ensure no padding around the button
            ),
            onPressed: () {},
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 50,
              shadows: [
                Shadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    offset: Offset(2.0, 2.0))
              ],
            ),
          ),
        ),
      ),
    );
  }

 // .................................. Image Button ...............................//
 Widget  galleryButton(){
   return Container(
     width: 50,
       height: 50,
       alignment: Alignment.center,
       child: FloatingActionButton(
         onPressed: (){
           getImage(ImageSource.gallery) ;

         },
         child: Icon(Icons.photo , size: 30,),
       )
   ) ;

 }

 // ..................................Camera Button ....................................//
Widget cameraButton(){
   return Container(
     height: 50,
       width: 50,
       alignment: Alignment.center,
       child: FloatingActionButton(
           onPressed: (){
             getImage(ImageSource.camera) ;
           },
           child: Icon(Icons.camera , size: 30,)
       )
   );
}

  Widget imagePickerContainer() {
    return pickedImage == null
        ? Container()
        : Center(
      child: Image.file(
        File(pickedImage!.path),
        height: 400,
      ),
    );
  }
}

