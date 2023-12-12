import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddFixtureTile extends StatelessWidget {
  void Function()? onPressed;

  AddFixtureTile({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: ListTile(
        title: Text("Add a new fixture"),
        subtitle: Text("Click to scan and add a fixture"),
        trailing: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
