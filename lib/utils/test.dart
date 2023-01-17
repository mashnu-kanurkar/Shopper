import 'package:flutter/material.dart';

import '../components/iconbutton.dart';
import '../navigator/navigator.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  List<Widget> widgetList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetList = getRowChildren();
    print("Done: $widgetList");
  }

  @override
  Widget build(BuildContext context) {
    print("build list $widgetList");
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          child: RwIconButton(
            icon: Icons.close_rounded,
            onTap: () {
              RwNavigator.pop(context: context);
            },
          ),
        ),
      ),
      body: Row(
        children: widgetList,
        // children: [
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //   Expanded(child: TextField(decoration: InputDecoration(hintText: "Text "),)),
        //
        // ],
      )
    );
  }

  List<Widget> getRowChildren(){
    List<Widget> widgetList = [];
    for(var i = 0; i <= 5; i++){
      print("Index: $i");
      widgetList.add(
        Expanded(child: TextField(decoration: InputDecoration(hintText: "Text $i"),)),
      );
    }
    print("Adding children: $widgetList");
    return widgetList;
  }
}

/*
ListView.builder(
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Text("Text $index");
        },
      ),
 */

//          Expanded(child: Center(child: TextField(decoration: InputDecoration(hintText: "Text 1"),))),