import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
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
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: GridView.builder(
              itemCount: 20,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => individualFolder(context))),
    );
  }

  Widget individualFolder(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              context.read<Pagecontrollerprovider>().changePage(2, context);
            },
            iconSize: 10.0,
            icon: Image.asset("asset/Icons/folder_icon.png")),
        const SizedBox(
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
    );
  }
}
