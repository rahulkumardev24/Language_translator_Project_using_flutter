import 'package:flutter/material.dart';
import '../dictionary/api.dart';
import '../dictionary/response_model_api.dart';
import '../utils/custom_text_style.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DictionaryScreen();
}

class _DictionaryScreen extends State<DictionaryScreen> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Starting Searching";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ----------------- App Bar ------------------///
      appBar: AppBar(
        title: Text(
          "Dictionary",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context) ;
          },
          child: Padding(
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            /// ----- SEARCH BOX ---------///
            _searchBoxWidget(),
            const SizedBox(
              height: 12,
            ),
            if (inProgress)
              const LinearProgressIndicator(
                color: Colors.orange,
              )
            else if (responseModel != null)
              Expanded(child: _buildResponseWidget())
            else
              _noDataWidget(),
          ],
        ),
      ),
    );
  }

  /// ............................ WIDGETS ..............................///

  /// Search widgets
  Widget _searchBoxWidget() {
    return TextField(
      controller: _searchController, // Added controller
      decoration: InputDecoration(
        hintText: "Search Word",
        hintStyle: myTextStyle18(
            fontWeight: FontWeight.bold, fontColor: Colors.black45),
        suffixIcon: InkWell(
          onTap: () {
            if (_searchController.text.isNotEmpty) {
              _getMeaningFromApi(
                  _searchController.text); // Get word from controller
            }
          },
          child: const Icon(Icons.search, color: Colors.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black45, width: 1),
        ),
      ),
    );
  }

  //.................. RESPONSE WIDGET ........................//
  _buildResponseWidget() {
    if (responseModel == null || responseModel!.meanings == null) {
      return _noDataWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            responseModel!.word ?? "",
            style: myTextStyle24(
                fontWeight: FontWeight.bold, fontColor: Colors.blue),
          ),
        ),
        Text(responseModel!.phonetic ?? ""),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildMeaningWidget(responseModel!.meanings![index]);
            },
            itemCount: responseModel!.meanings!.length,
          ),
        ),
      ],
    );
  }

  // ................... Meaning Widget...................//

  _buildMeaningWidget(Meanings meanings) {
    String definitionList = "";
    meanings.definitions?.forEach((element) {
      int index = meanings.definitions!.indexOf(element);
      definitionList += "\n${index + 1}. ${element.definition}\n";
    });

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech ?? "",
              style: myTextStyle18(
                  fontColor: Colors.orange.shade700,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Definitions: ",
                style: myTextStyle15(fontWeight: FontWeight.bold)),
            Text(definitionList),
            _buildSynonyms("Synonyms", meanings.synonyms),
            _buildAntonyms("Antonyms", meanings.antonyms),
          ],
        ),
      ),
    );
  }

  // ......................Synonyms......................//
  _buildSynonyms(String title, List<String>? synonymsList) {
    if (synonymsList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: myTextStyle18(
                fontColor: Colors.orange.shade700, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            synonymsList!
                .toSet()
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", ""),
            style: myTextStyle15(),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // ..........................Antonyms.....................//
  _buildAntonyms(String title, List<String>? antonymsList) {
    if (antonymsList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: myTextStyle18(
                fontColor: Colors.orange.shade700, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
              antonymsList!
                  .toSet()
                  .toString()
                  .replaceAll("{", "")
                  .replaceAll("}", ""),
              style: myTextStyle15()),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  //.......................NO DATA WIDGET ......................//

  _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: myTextStyle18(),
        ),
      ),
    );
  }

  // .................. FUNCTION FOR GET MEANING FROM API..........................//
  _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
    } catch (e) {
      responseModel = null;
      noDataText = "Meaning is Not Found";
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
