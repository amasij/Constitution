import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Bookmark extends StatefulWidget {
  static String get routeName => '/bookmarks';
  @override
  BookmarkState createState() => BookmarkState();
}

class BookmarkState extends State<Bookmark> {
  File jsonFile;
  Directory dir;
  String fileName = "bookmarks.json";
  bool fileExists = false;
  var keyId = '\\';
  var keys = [];
  Map<String, dynamic> fileContent = {};
  @override
  void initState() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        //jsonFile.deleteSync();
        // return;
        this.setState(() {
          fileContent = json.decode(jsonFile.readAsStringSync());
          keys = fileContent.keys.toList();
          setState(() {});
        });
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    // print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void removeBookmark(String keyId) {
    fileContent.remove(keyId);
    keys = fileContent.keys.toList();
    createFile(fileContent, dir, fileName);
  }

  void emptyMap() {
    fileContent.clear();
    keys = fileContent.keys.toList();
    createFile(fileContent, dir, fileName);
  }

  Widget createBookmark(dynamic title) {
    var content = fileContent[title];
    List<Widget> contentWidget = [];
    contentWidget.add(SizedBox(
      height: 15.0,
    ));
    contentWidget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child:Container(padding: EdgeInsets.only(left:6.0),child: Text(title,
                overflow: TextOverflow.fade,
                softWrap: false,
                
                style: TextStyle(
                    color: Colors.yellow[800], fontWeight: FontWeight.bold)),) ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.green,
          ),
          onPressed: () {
            removeBookmark(title);
            setState(() {
              Toast.show("Bookmark Removed", context,
                  gravity: Toast.BOTTOM, backgroundColor: Colors.green);
            });
          },
        )
      ],
    ));
    contentWidget.add(SizedBox(
      height: 25.0,
    ));
    //print(content.toString());
    for (var i = 0; i < content.length; i++) {


                 try {
              int.parse(content[i][1]);
             contentWidget.add( Card(
                child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(content[i]),
                ),
              ));
            } catch (e) {
              var check = false;
              if (content[i][0] == '(') check = true;
             contentWidget.add(Card(
                child: Padding(
                  padding: check
                      ? EdgeInsets.only(left: 15.0, top: 4.0, bottom: 4.0)
                      : EdgeInsets.all(7.0),
                  child: Text(content[i]),
                ),
              ));
            }

      //contentWidget.add(
      // Text( content[i])
       //  );
      contentWidget.add(SizedBox(
        height: 15.0,
      ));
    }

    return Card(
      margin: EdgeInsets.only(bottom: 30.0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: contentWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        backgroundColor: Colors.greenAccent[600],
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              emptyMap();
              setState(() {
                Toast.show("All Bookmarks Removed", context,
                    gravity: Toast.BOTTOM, backgroundColor: Colors.green);
              });
            },
          )
        ],
      ),
      body: Theme(
          data: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.greenAccent[600],
              accentColor: Colors.greenAccent[400],
              indicatorColor: Colors.green[700],

              // Define the default font family.
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                body1: TextStyle(fontSize: 17.0, fontFamily: 'Hind'),
              )),
          child: keys.length != 0
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return createBookmark(keys[index]);
                  },
                  itemCount: keys == null ? 0 : keys.length,
                )
              : Center(
                  child: Text('No Bookmarks'),
                )),
    );
  }
}
