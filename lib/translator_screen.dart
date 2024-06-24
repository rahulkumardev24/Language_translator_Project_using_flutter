import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var originLanguage = "from";
  var destinationLanguage = "To";
  var outputLanguage = "";
  TextEditingController languageController = TextEditingController();


  bool isSpeaking = false;
  bool isButtonPressed = false;



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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Translator"),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
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
                userInputTextBox(),
                const SizedBox(height: 10),
                translatedButton(),
                const SizedBox(height: 10),
                outputTextBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fromLanguageList() {
    return Container(
      height: 60,
      width: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(1.0, 2.0))
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
                fontWeight: FontWeight.bold
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
              originLanguage = value!;
            });
          },
        ),
      ),
    );
  }

  Widget toLanguageList() {
    return Container(
      height: 60,
      width: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(1.0, 2.0))
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

  Widget userInputTextBox() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        autocorrect: true,
        maxLines: 3,
        cursorColor: Colors.deepOrange,
        autofocus: true,
        style: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(10)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.tealAccent)
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(10)
          ),
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

  Widget translatedButton() {
    return Container(
      width: 300,
      child: FloatingActionButton(
        onPressed: () {
          translate(
              languageCode(originLanguage),
              languageCode(destinationLanguage),
              languageController.text.toString()
          );
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

  Widget outputTextBox() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.deepOrange)
        ),
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
                  "\n$outputLanguage",
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget speakIconButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isButtonPressed = true;
        });

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
}
