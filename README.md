# PixLED Bluetooth Application

The PixLED Bluetooth Application is a project aimed at creating an application that empowers users to control LED strips through Bluetooth communication. This involves integrating the app with an ESP32 configured to manage and manipulate LED strip functionalities. 

## Table of Contents

- [PixLED Bluetooth Application](#pixled-bluetooth-application)
  - [Table of Contents](#table-of-contents)
  - [Getting Started with Flutter](#getting-started-with-flutter)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)


## Getting Started with Flutter

The project is based on a boilerplate for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

- Bluetooth integration with WS2811 LED strip.
- Control LED brightness, color, and state.
- Automatic LED strip initialization upon connection.

## Requirements

- Android phone
- [Flutter Blue Plus library](https://pub.dev/packages/flutter_blue_plus).
- [Flutter Flex colorpicker library](https://pub.dev/packages/flex_color_picker)

## Installation

1. Clone the repository.
2. Open in VSCode
3. Install Flutter: https://docs.flutter.dev/get-started/install
4. Set up VSCode: https://docs.flutter.dev/get-started/editor
5. Connect your android phone to your computer using a USB-C cable
6. Enable developper option and USB debugging on your phone: https://developer.android.com/studio/debug/dev-options


## Usage

1. Execute the project in the project's root folder using your terminal : ```flutter run ```
2. Connect the LED strips and the ESP32 following this demo: https://github.com/madoyon/pixled_firmware
3. On the app, scan, add the ESP32 and control your lights!

## Contributing

Contributions are welcome!

## License

This project is licensed under the MIT License.

## Acknowledgments

- rydmike.com for the flex color picker contribution on Flutter
- jamcorder.com for the Flutter Blue Plus package on Flutter