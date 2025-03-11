import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translater_new/screen/chat_screen.dart';
import 'package:translater_new/screen/dictionary_screen.dart';
import 'package:translater_new/screen/translator_screen.dart';
import 'package:translater_new/utils/custom_text_style.dart';

import '../model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  List<CategoryModel> categories = [
    CategoryModel(
        image: Image.asset("assets/images/word.png"), title: "Dictionary"),
    CategoryModel(
        image: Image.asset("assets/images/trans.png"), title: "Translation"),
    CategoryModel(
        image: Image.asset("assets/images/anto.png"), title: "Antonyms"),
    CategoryModel(
        image: Image.asset("assets/images/synon.png"), title: "Synonyms"),
    CategoryModel(image: Image.asset("assets/images/book.png"), title: "Book"),
    CategoryModel(image: Image.asset("assets/images/eng.png"), title: "Learn"),
    CategoryModel(image: Image.asset("assets/images/chat.png"), title: "Chat"),
    CategoryModel(image: Image.asset("assets/images/man.png"), title: "Male"),
    CategoryModel(
        image: Image.asset("assets/images/female.png"), title: "Female"),
  ];

  MediaQueryData? mqData;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);

    return Scaffold(
      /// ----------------- App Bar ------------------///
      appBar: AppBar(
        title: Text(
          "Language Tools",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black12),
              child: const Icon(
                Icons.backspace_outlined,
                color: Colors.black87,
              )),
        ),
      ),
      backgroundColor: Colors.white,

      ///--------------------BODY-----------------------------///
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (categories[index].title == "Dictionary") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DictionaryScreen()));
                  } else if (categories[index].title == "Translation") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LanguageTranslatorScreen()));
                  } else if (categories[index].title == "Chat") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  }
                },
                child: Card(
                  color: Colors.blue.shade50,
                  elevation: 1,
                  child: GridTile(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Image
                        SizedBox(
                          height: mqData!.size.height * 0.1,
                          width: mqData!.size.height * 0.1,
                          child: categories[index].image,
                        ),
                        const SizedBox(height: 6,),
                        /// Title
                        Text(
                          categories[index].title,
                          style: myTextStyle24(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
