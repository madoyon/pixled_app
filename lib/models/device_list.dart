import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lumos_app/models/light_fixture_model.dart';

class DeviceList extends ChangeNotifier {
  // final List<BluetoothDevice> _fixtures = [];
  // final List<LightFixtureModel> _light_fixtures = [];

  final List<Device> _devices = [];

  // void addFixture(BluetoothDevice fixture, FixtureType type) {
  //   if (type == FixtureType.light) {
  //     // Add to the light fixtures list or perform additional logic for light fixtures
  //     _light_fixtures.add(LightFixtureModel(device: fixture));
  //   }
  //   notifyListeners();
  // }

  void addDevice(BluetoothDevice device, DeviceType deviceType) {
    if (deviceType == DeviceType.lightFixture) {
      // Add to the light fixtures list or perform additional logic for light fixtures
      _devices.add(LightFixtureModel(device: device));
    }
    notifyListeners();
  }

  // void removeFixture(BluetoothDevice fixture, FixtureType type) {
  //   if (type == FixtureType.light) {
  //     // Add to the light fixtures list or perform additional logic for light fixtures
  //     _light_fixtures
  //         .removeWhere((lightFixture) => lightFixture.device == fixture);
  //   }
  //   notifyListeners();
  // }

  void removeDevice(BluetoothDevice fixture, DeviceType type) {
    if (type == DeviceType.lightFixture) {
      // Add to the light fixtures list or perform additional logic for light fixtures
      _devices.removeWhere((lightFixture) => lightFixture.device == fixture);
    }
    notifyListeners();
  }

  void removeAll() {
    _devices.clear();
    notifyListeners();
  }

  //get fixture list
  // List<BluetoothDevice> get fixtureList => _fixtures;
  // List<LightFixtureModel> get lightFixtures => _light_fixtures;
  List<Device> get devices => _devices;
}
