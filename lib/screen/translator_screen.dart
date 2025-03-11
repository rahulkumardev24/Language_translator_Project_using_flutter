import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translater_new/screen/category_screen.dart';
import 'package:translater_new/utils/custom_text_style.dart';
import 'package:translator/translator.dart';

class LanguageTranslatorScreen extends StatefulWidget {
  const LanguageTranslatorScreen({super.key});

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
    initializedTts(); // here we call initializedTts
    initializedSpeechToText();

    /// user box is empty then automatic output text empty
    languageController.addListener(() {
      setState(() {
        outputLanguage = languageController.text.isEmpty ? "" : outputLanguage;
      });
    });
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

  void _speak(String text) async {
    if (isSpeaking) {
      // If speaking, stop the speech
      await _flutterTts.stop();
    } else {
      // If not speaking, start speaking the text
      await _flutterTts.speak(text);
    }
    setState(() {
      isSpeaking = !isSpeaking; // Toggle the speaking state
    });
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
    setState(() {});
  }

  // ............IMAGE PICKER AND CAMERA , IMAGE TEXT INTO TEXT ...............//
  XFile? pickedImage;
  String myText = "";
  bool scanning = false;
  final ImagePicker imagePicker = ImagePicker();

  getImage(ImageSource ourSource) async {
    XFile? result = await imagePicker.pickImage(source: ourSource);
    if (result != null) {
      setState(() {
        pickedImage = result;
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
        languageController.text =
            recognizedText.text; // Update the languageController text
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

  bool isDarkMode = false;

  /// Default mode is light

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;

      /// Toggle theme
    });
  }

  late MediaQueryData mqData;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      /// ........................................APP BAR .........................................///
      appBar: AppBar(
        title: Text(
          "Language translator",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              },
              child: Image.asset("assets/images/category.png")),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,

        /// Light and dark them
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: toggleTheme,
              child: Icon(
                isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 30,
                color: isDarkMode ? const Color(0xff5E4DB2) : Colors.orange,
              ),
            ),
          ),
        ],
      ),

      // .......................Mic FloatingActionButton ....................//
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Gallery Button
          galleryButton(),

          /// Here we call Floating Mic Button
          micButton(),

          /// here we call camera button
          cameraButton()
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Language selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// From language
                  fromLanguageList(),
                  const Icon(
                    Icons.arrow_right_alt_outlined,
                    color: Colors.black45,
                    size: 40,
                  ),

                  /// To language
                  toLanguageList()
                ],
              ),

              const SizedBox(height: 10),

              /// selected image container
              imagePickerContainer(),
              const SizedBox(height: 10),

              /// user input box
              userInputTextBox(),
              const SizedBox(height: 10),

              /// translated button
              translatedButton(),
              const SizedBox(height: 10),
              outputLanguage.isNotEmpty ? outputTextBox() : const SizedBox(),
              SizedBox(
                height: mqHeight * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///........................................WIDGETS..........................//

  ///.......................FROM LANGUAGE LIST BOX ....................................//

  Widget fromLanguageList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        /// Removes the underline
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: DropdownButton(
            focusColor: Colors.tealAccent,
            iconDisabledColor: Colors.blue.shade100,
            iconEnabledColor: Colors.blue.shade100,
            alignment: Alignment.center,
            iconSize: 30,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            elevation: 1,
            borderRadius: BorderRadius.circular(5),
            style: myTextStyle15(),
            menuMaxHeight: mqData.size.height * 0.4,
            hint: Text(originLanguage, style: myTextStyle24()),
            dropdownColor: Colors.blue.shade50,
            items: languageList.map((String dropDownStringItem) {
              return DropdownMenuItem(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem,
                  style: myTextStyle18(),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                originLanguage = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  ///..................... To LANGUAGE LIST BOX ...........................//
  Widget toLanguageList() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.only(right: 21.0),
          child: DropdownButton(
            iconSize: 30,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            focusColor: Colors.tealAccent,
            iconDisabledColor: Colors.blue.shade100,
            iconEnabledColor: Colors.blue.shade100,
            alignment: Alignment.center,
            elevation: 1,
            borderRadius: BorderRadius.circular(5),
            style: myTextStyle15(),
            menuMaxHeight: mqData.size.height * 0.4,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(destinationLanguage, style: myTextStyle24()),
            ),
            dropdownColor: Colors.blue.shade50,
            items: languageList.map((String dropDownStringItem) {
              return DropdownMenuItem(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem,
                  style: myTextStyle18(),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                destinationLanguage = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  ///......................... USER INPUT BOX ...........................//

  Widget userInputTextBox() {
    return TextFormField(
      autocorrect: true,
      maxLines: 500,
      minLines: 5,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      cursorColor: Colors.black54,
      autofocus: false,
      style: myTextStyle15(),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.tealAccent),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1, color: Colors.black45)),
        hintText: "Type text to translate...",
        hintStyle: myTextStyle15(
            fontColor: Colors.black45, fontWeight: FontWeight.bold),
      ),
      controller: languageController,
    );
  }

  ///....................TRANSLATED BUTTON ................................//

  Widget translatedButton() {
    return SizedBox(
      width: mqData.size.width,
      child: ElevatedButton(
        onPressed: () {
          if (languageController.text.isNotEmpty) {
            /// when click on button
            translate(
                languageCode(originLanguage),
                languageCode(destinationLanguage),
                languageController.text.toString());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Type text to translate...",
                style: myTextStyle18(fontColor: Colors.white),
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                  label: "Ok",
                  textColor: Colors.black54,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
            ));
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.tealAccent.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(
          "Translate",
          style: myTextStyle24(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  ///...................OUTPUT TEXT BOX .....................................//

  Widget outputTextBox() {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              languageController.text.isEmpty ? "" : outputLanguage,
              cursorColor: Colors.red,
              showCursor: true,
              style: myTextStyle18(fontColor: Colors.blueAccent),
            ),
          ),
        ),
        Positioned(top: 0, right: 0, child: speakIconButton())
      ],
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
        setState(() {
          isButtonPressed = false;
        });
      },
      icon: const Icon(Icons.volume_up_sharp),
      color: isSpeaking ? Colors.orange : Colors.black,
    );
  }

  // ............................MIC FLOATING ACTION BUTTON ....................//
  Widget micButton() {
    return AvatarGlow(
      animate: startRecording,
      startDelay: const Duration(milliseconds: 100),
      glowColor: Colors.blueAccent,
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            startRecording = true;
          });
          if (isAvailable) {
            speechToText.listen(onResult: (result) {
              setState(() {
                languageController.text = result.recognizedWords;
              });
            });
          }
        },
        onTapUp: (value) {
          setState(() {
            startRecording = false;
          });
          speechToText.stop();
        },
        onTapCancel: () {
          setState(() {
            startRecording = false;
          });
          speechToText.stop();
        },
        child: Container(
          height: mqData.size.height * 0.07,
          width: mqData.size.height * 0.07,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 1)
              ]),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.tealAccent,
              padding: const EdgeInsets.all(
                  0), // Ensure no padding around the button
            ),
            onPressed: () {},
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // .................................. Image Button ...............................//
  Widget galleryButton() {
    return Container(
        width: mqData.size.height * 0.1,
        height: mqData.size.height * 0.1,
        alignment: Alignment.center,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.blue.shade100,
          heroTag: null,
          onPressed: () {
            getImage(ImageSource.gallery);
          },
          child: const Icon(
            Icons.photo,
            size: 30,
            color: Colors.black87,
          ),
        ));
  }

  // ..................................Camera Button ....................................//
  Widget cameraButton() {
    return Container(
        width: mqData.size.height * 0.1,
        height: mqData.size.height * 0.1,
        alignment: Alignment.center,
        child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.blue.shade100,
            heroTag: null,
            onPressed: () {
              getImage(ImageSource.camera);
            },
            child: const Icon(
              Icons.camera,
              size: 30,
              color: Colors.black87,
            )));
  }

  /// image picker widget
  Widget imagePickerContainer() {
    return pickedImage == null
        ? Container()
        : Center(
            child: Stack(
              children: [
                Image.file(
                  File(pickedImage!.path),
                  fit: BoxFit.cover,
                ),

                /// Delete button
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white30,
                    ),
                    child: InkWell(
                      onTap: () {
                        /// Clear the image
                        setState(() {
                          pickedImage = null;
                        });

                        /// Clear text input and output
                        outputLanguage = "";
                        languageController.clear();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.delete_forever,
                            size: 30, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
