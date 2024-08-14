import 'package:aspireme_flutter/CommonllyUsedComponents/CustomTopAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Noteseditingpage extends StatelessWidget {
  String title;
  String discription;
  Noteseditingpage({this.discription = "", this.title = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Customtopappbar(),
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [titleInput(), discriptionInput()],
          )),
    );
  }

  Widget titleInput() {
    return TextField(
      decoration: InputDecoration(labelText: this.title),
    );
  }

  Widget discriptionInput() {
    return TextField(
      decoration: InputDecoration(labelText: this.discription),
    );
  }
}
