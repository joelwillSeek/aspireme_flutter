import 'package:aspireme_flutter/CommonllyUsedComponents/Notes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestNote {
  String title;
  String Discription;
  DateTime dateTime = DateTime.now();

  TestNote({this.title = "Test", this.Discription = "Test"});
}

class Viewindividualfolder extends StatelessWidget {
  Viewindividualfolder({super.key});

  List<TestNote> items = [
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum"""),
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum"""),
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum"""),
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum"""),
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum"""),
    TestNote(
        title: "testing things",
        Discription:
            """Ipsum has been the industry's standard dummy text ever since 
            the 1500s, when an unknown printer took a galley of type and scrambled it to make a 
            type specimen book. It has survived not only five centuries, but also the leap into electronic 
            typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of 
            Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software 
            like Aldus PageMaker including versions of Lorem Ipsum""")
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Notes(
                title: items[index].title,
                discription: items[index].Discription)));
  }
}
