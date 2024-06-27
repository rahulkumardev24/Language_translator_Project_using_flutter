import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translater_new/screen/dictionary_screen.dart';

import '../model/category_model.dart';

class CategoryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CategoryScreen();
}
class _CategoryScreen extends State<CategoryScreen>{

  List<CategoryModel> categories = [
    CategoryModel(image: Image.asset("assets/images/dict.png"), title: "Dictionary"),
    CategoryModel(image: Image.asset("assets/images/eng.png"), title: "Learn"),
    CategoryModel(image: Image.asset("assets/images/chat.png"), title: "Chat"),
    CategoryModel(image: Image.asset("assets/images/man.png"), title: "Male"),
    CategoryModel(image: Image.asset("assets/images/female.png"), title: "Female"),
  ];

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Category"), centerTitle: true ,
    ),
    
    body: GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              if (categories[index].title == "Dictionary") {
                Navigator.push(context,MaterialPageRoute(builder: (context) => DictionaryScreen()));
              }
            },
            child: Card(
              elevation: 10,
              child: GridTile(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                        width: 50,
                        child: categories[index].image),
                    Text(categories[index].title , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );

  }

}