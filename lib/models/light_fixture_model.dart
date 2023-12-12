import "dart:core";
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum FixtureState { off, on }

FixtureState intToFixtureState(int value) {
  switch (value) {
    case 0:
      return FixtureState.off;
    case 1:
      return FixtureState.on;
    default:
      throw ArgumentError('Invalid FixtureState value: $value');
  }
}

enum DeviceType {
  lightFixture,
  other,
}

class LightFixtureModel implements Device {
  BluetoothDevice _device;
  String _serviceUuid;
  late BluetoothService _service;
  late BluetoothCharacteristic _lightControlCharacteristic;
  static const String _lightControlCharacteristicUuid =
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  int _brightness;
  int _colorHex; //Format 0xRRGGBB
  FixtureState _state;
  bool _isInitialized = false;

  // Default UUIDs for characteristics

  // Constructor with required parameters
  LightFixtureModel({
    required BluetoothDevice device,
    var brightness,
    var colorHex,
    var isInitialized,
    FixtureState? state,
    String? serviceUuid,
  })  : _device = device,
        _serviceUuid = "",
        _brightness = brightness ?? 0, //Brightness set to 0
        _colorHex = colorHex ?? 0xff42a5f5, //Blue color as default
        _state = state ?? FixtureState.off,
        _isInitialized = isInitialized ?? false {}

  // Getters for accessing private fields
  BluetoothDevice get device => _device;
  String get serviceUuid => _serviceUuid;
  BluetoothCharacteristic get lightControlCharacteristic =>
      _lightControlCharacteristic;
  BluetoothService get service => _service;
  get brightness => _brightness;
  get colorHex => _colorHex;
  get state => _state;
  get isInitialized => _isInitialized;

  // Setters for updating characteristic values
  void setColor(int colorHex) {
    // Convert colorHex to the appropriate format and set the value on the characteristic
    _colorHex = colorHex;
  }

  void setBrightness(int brightness) {
    // Set the brightness value on the characteristic
    _brightness = brightness;
  }

  void setState(FixtureState newState) {
    // Set the state value on the characteristic (0 for off, 1 for on)
    _state = newState;
  }

  void setServiceUuid(String serviceUuid) {
    _serviceUuid = serviceUuid;
  }

  void setService(BluetoothService service) {
    _service = service;
  }

  void setIsInitialized(bool isInitialized) {
    _isInitialized = isInitialized;
  }

  void setLightControlCharacteristic(
      BluetoothCharacteristic lightControlCharacteristic) {
    _lightControlCharacteristic = lightControlCharacteristic;
  }

  void extractRelevantService() {
    for (BluetoothService service in _device.servicesList) {
      if (service.uuid
          .toString()
          .contains("4fafc201-1fb5-459e-8fcc-c5c9c331914b")) {
        setService(service);
      }
    }
  }

  void extractLightControlCharacteristic() {
    for (BluetoothService service in device.servicesList) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == _lightControlCharacteristicUuid) {
          setLightControlCharacteristic(characteristic);
        }
      }
    }
  }

  void extractInitializationValues(List<int> initValues) {
    int buildColorHex = 0;

    buildColorHex += initValues[1] << 16;
    buildColorHex += initValues[2] << 8;
    buildColorHex += initValues[3];

    setColor(buildColorHex);
    setBrightness(initValues[4]);
    setState(intToFixtureState(initValues[5]));
    setIsInitialized(true);
  }

  List<int> buildBluetoothMessage() {
    List<int> dataBytes = [];

    dataBytes.add(isInitialized ? 1 : 0);
    dataBytes.add((colorHex & 0x00FF0000) >> 16);
    dataBytes.add((colorHex & 0x0000FF00) >> 8);
    dataBytes.add(colorHex & 0x000000FF);
    dataBytes.add(brightness); //Add brightness value 0-255
    dataBytes.add(state.index); //Add state 0 or 1

    return dataBytes;
  }

  @override
  DeviceType _deviceType = DeviceType.lightFixture;

  @override
  DeviceType get deviceType => _deviceType;
}

class Device {
  BluetoothDevice _device;
  DeviceType _deviceType;

  Device({
    required BluetoothDevice device,
    required DeviceType deviceType,
  })  : _device = device,
        _deviceType = deviceType;

  BluetoothDevice get device => _device;
  DeviceType get deviceType => _deviceType;
}
