import 'package:flutter/material.dart';
Widget contentsearch(BuildContext context, String query, String content,
    String chapter, String section, String part) {

  String newString;
  final wordToStyle = query;
  final style = TextStyle(color: Colors.green);

  var contents = content.split('@').where((i) {
    if (i.trim() == '')
      return false;
    else
      return true;
  }).toList();

  newString = contents.join('\n\n');

 
  final spans = getSpans(newString, wordToStyle, style);
  Widget header;
  if (part == null)
  {
   header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child:  Container(padding: EdgeInsets.only(left:6.0),child:Text( '$chapter\nSection- $section',
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    color: Colors.yellow[800], fontWeight: FontWeight.bold)))
                    ),
       SizedBox()
      ],
    );
   
   
   

  }
 
  else
  {
   header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: Container(padding: EdgeInsets.only(left:6.0),child:Text( '$chapter\n$part\nSection- $section',
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    color: Colors.yellow[800], fontWeight: FontWeight.bold)
                    ))),
        SizedBox()
      ],
    );

  }

  return Card(
    child: Container(
     
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 3.0,
          ),
          header,
          SizedBox(
            height: 5.0,
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: RichText(
                text: TextSpan(
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
                  children: spans,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

List<TextSpan> getSpans(String text, String matchWord, TextStyle style) {
  List<TextSpan> spans = [];
  int spanBoundary = 0;

  do {
    // look for the next match
    final startIndex =
        text.toLowerCase().indexOf(matchWord.toLowerCase(), spanBoundary);

    // if no more matches then add the rest of the string without style
    if (startIndex == -1) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

    // add any unstyled text before the next match
    if (startIndex > spanBoundary) {
      spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
    }

    // style the matched text
    final endIndex = startIndex + matchWord.length;
    final spanText = text.substring(startIndex, endIndex);
    spans.add(TextSpan(text: spanText, style: style));

    // mark the boundary to start the next search from
    spanBoundary = endIndex;

    // continue until there are no more matches
  } while (spanBoundary < text.length);

  return spans;
}
