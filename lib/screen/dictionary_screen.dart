import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translater_new/api/api.dart';
import 'package:translater_new/api/response_model_api.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DictionaryScreen();
}

class _DictionaryScreen extends State<DictionaryScreen> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Starting Searching";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _searchBoxWidget(),
            const SizedBox(
              height: 12,
            ),
            if (inProgress)
              const LinearProgressIndicator()
            else if (responseModel != null)
              Expanded(child: _buildResponseWidget())
            else
              _noDataWidget(),
          ],
        ),
      ),
    );
  }

  // ............................ WIDGETS ..............................//

  _searchBoxWidget() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Word",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onSubmitted: (value) {
        _getMeaningFromApi(value);
      },
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
        SizedBox(height: 16),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            responseModel!.word ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.blueAccent,
            ),
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
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech ?? "",
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            const Text(
              "Definitions: ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            synonymsList!
                .toSet()
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", ""),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return SizedBox.shrink();
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
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            antonymsList!
                .toSet()
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", ""),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  //.......................NO DATA WIDGET ......................//

  _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
