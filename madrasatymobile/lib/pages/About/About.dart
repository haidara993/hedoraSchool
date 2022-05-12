import 'package:flutter/material.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          title: "About!",
        ),
        body: Container());
  }
}
