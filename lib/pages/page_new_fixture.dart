import 'package:flutter/material.dart';
import 'package:lumos_app/components/add_fixture_tile.dart';
import 'package:lumos_app/pages/page_fixture_scan.dart';

class NewFixturePage extends StatelessWidget {
  const NewFixturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            size: 25,
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(children: [
          AddFixtureTile(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const FixtureScanPage();
              }),
            );
          })
        ]),
      ),
    );
  }
}
