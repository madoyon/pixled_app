import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'dart:async';

class ColorPage extends StatefulWidget {
  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  double currentSliderValue = 0.0;
  late Color screenPickerColor = Colors.blue;
  // Material blue.
  late Color dialogPickerColor = Colors.red;
  // Material red.
  late Color dialogSelectColor = const Color(0xFFA239CA);

  double maxValueSlider = 100.0;

  Timer? timer;

  bool lightState = false;
  // A purple color.
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          Row(
            children: [
              Text(
                "Brightness : ${currentSliderValue.round()}%",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                width: 50,
              ),
              Switch(
                value: lightState,
                onChanged: (value) {
                  setState(() {
                    lightState = value;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              decreaseBrightnessButton(context),
              Expanded(child: brightnessSlider()),
              increaseBrightnessButton(context),
            ],
          ),
          colorPicker(context),
        ],
      ),
    ]);
  }

  GestureDetector increaseBrightnessButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (currentSliderValue < maxValueSlider) {
            currentSliderValue++;
          }
        });
      },
      onLongPress: () {
        print("Long press");
        timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
          print("Increment");
          // timer?.cancel();
          setState(() {
            if (currentSliderValue < maxValueSlider) {
              currentSliderValue++;
            }
          });
        });
      },
      onLongPressEnd: (_) {
        print("Long press ended");
        timer?.cancel();
      },
      child: Icon(Icons.add_circle_outline,
          color: Theme.of(context).colorScheme.primary),
    );
  }

  GestureDetector decreaseBrightnessButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (currentSliderValue > 0.0) {
            currentSliderValue--;
          }
        });
      },
      onLongPress: () {
        print("Long press");
        timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
          print("Decrement");
          // timer?.cancel();
          setState(() {
            if (currentSliderValue > 0.0) {
              currentSliderValue--;
            }
          });
        });
      },
      onLongPressEnd: (_) {
        print("Long press ended");
        timer?.cancel();
      },
      child: Icon(Icons.remove_circle_outline,
          color: Theme.of(context).colorScheme.primary),
    );
  }

  ColorPicker colorPicker(BuildContext context) {
    return ColorPicker(
      // Use the screenPickerColor as start color.
      color: screenPickerColor,
      // Update the screenPickerColor using the callback.
      onColorChanged: (Color color) {
        setState(
          () {
            screenPickerColor = color;
            print(color);
          },
        );
      },
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 200,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,

      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.wheel: true,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
      },
    );
  }

  Slider brightnessSlider() {
    return Slider(
      value: currentSliderValue,
      max: maxValueSlider,
      divisions: 100,
      label: currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          currentSliderValue = value;
          print(currentSliderValue);
        });
      },
    );
  }
}
