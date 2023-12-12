import 'package:flutter/material.dart';

class FixtureTile extends StatelessWidget {
  const FixtureTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: ListTile(
        leading: Icon(
          Icons.lightbulb,
          size: 30.0,
        ),
        title: Text('Test'),
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 30,
        ),
      ),
    );
  }
}
