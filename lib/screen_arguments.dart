import 'package:flutter/material.dart';
class ScreenArguments {
  final String title;
  final String content;
  final keyId;


  ScreenArguments(this.title, this.content,this.keyId);
}

class ScreenArgumentsforSectionSearch {
  Widget title;
  final String content;


 ScreenArgumentsforSectionSearch(this.title, this.content);
}

class SearchArgs {
  List<Widget> searchresult;
  String query;

  SearchArgs(List<Widget> searchresult, String query) {
    this.searchresult = searchresult;
    this.query = query;
  }
}