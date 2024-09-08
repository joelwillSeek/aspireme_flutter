import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didpop) => false,
        child: Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: SpinKitFadingFour(
                    color: Theme.of(context).colorScheme.primary),
              )),
        ));
  }
}
