import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  // RangeError.range(-2,-1, 100);
  int index =
      0; //keeps track of the images and and the text to be displayed in synchronize way
  int millisec = 0; // keep track of lag to be given in animation
  List<String> textInfo = [];
  List<String> titles = [];
  List<String> images = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('load_json/hello.json');
    final data = await json.decode(response);
    if (data["en"].length > 0) {
      data["en"].forEach((element) {
        titles.add(element["title"]);
        images.add(element["image"]);
      });
    }
  }

  @override
  void initState() {
    readJson(); // loads json file
    millisec = 200;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: NetworkImage(images[index]),
              // fit: BoxFit.fill
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(65),
              width: double.infinity,
              color: Colors.black38,
              child: TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: millisec),
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
                text: titles,
                onNext: (int pos, bool isLast) => {
                  //call back() function which will keep track of image and title in a
                  // synchronized manner using index
                  setState(() {
                    index = (index + 1) % images.length;
                  })
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: ElevatedButton(
                        // color:Colors.transparent,
                        onPressed: () {
                          setState(() {
                            millisec = millisec - 100; // track of lag
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              Icons.minimize_rounded,
                              color: Colors.white,
                              size: 20,
                            )))),
                Container(
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12))),
                    child: ElevatedButton(
                        // color:Colors.transparent,
                        onPressed: () {
                          millisec = millisec + 100;
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ))),
              ],
            ),
            FittedBox(
                child: Container(
                    padding: EdgeInsets.only(
                        top: 12, left: 12, right: 12, bottom: 8),
                    alignment: Alignment.center,
                    color: Colors.grey[50],
                    child: Text("Lag:$millisec ms",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold))))
            // child:FadeAnimatedText(text:myData[index]["title"],)
          ],
        ),
      ),
    );
  }
}
