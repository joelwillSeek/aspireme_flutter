import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Folderlistpage extends StatelessWidget {
  const Folderlistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration:
            BoxDecoration(color: context.read<ThemeProvider>().getPrimaryColor),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: context.read<ThemeProvider>().getAccentColor,
                height: 3.0,
                margin: EdgeInsets.only(top: 140.0),
              ),
            ),
            Expanded(
                child: GridView.builder(
                    itemCount: 20,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) => Column(
                          children: [
                            IconButton(
                                onPressed: null,
                                iconSize: 10.0,
                                icon:
                                    Image.asset("asset/Icons/folder_icon.png")),
                            SizedBox(
                                width: 100.0,
                                height: 40.0,
                                child: Text(
                                  "Folder Name",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  softWrap: false,
                                )),
                          ],
                        ))),
            Placeholder(
              color: Colors.transparent,
              fallbackHeight: 80.0,
            )
          ],
        ),
      ),
    );
  }
}
