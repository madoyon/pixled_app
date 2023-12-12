import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos_app/components/characteristic_tile.dart';
import 'package:lumos_app/components/descriptor_tile.dart';
import "dart:async";

import 'package:lumos_app/components/extra.dart';
import 'package:lumos_app/components/service_tile.dart';
import 'package:lumos_app/models/light_fixture_model.dart';

class LightFixturePage extends StatefulWidget {
  const LightFixturePage({super.key, required this.device});

  final LightFixtureModel device;

  @override
  State<LightFixturePage> createState() => _LightFixturePageState();
}

class _LightFixturePageState extends State<LightFixturePage> {
  late Color screenPickerColor = Colors.blue;
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isSubscribing = false;
  bool _isConnectingOrDisconnecting = false;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingOrDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;

  late StreamSubscription<List<int>> _lastValueSubscription;
  List<int> _value = [];

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.device.readRssi();
      }

      setState(() {});
    });

    _mtuSubscription = widget.device.device.mtu.listen((value) {
      _mtuSize = value;
      setState(() {});
    });

    _isConnectingOrDisconnectingSubscription =
        widget.device.device.isConnectingOrDisconnecting.listen((value) {
      _isConnectingOrDisconnecting = value;
      setState(() {});
    });

    onDiscoverServicesPressed();
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingOrDisconnectingSubscription.cancel();
    _lastValueSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.device.connectAndUpdateStream();
      print("Connect: Success");
    } catch (e) {
      print("Connect Error:");
    }
  }

  Future onInitialization() async {
    if (widget.device.isInitialized == false) {
      //Enable the control variable
      _lastValueSubscription = widget
          .device.lightControlCharacteristic.lastValueStream
          .listen((value) {
        _value = value;
        setState(() {});
      });
      List<int> initializationValues =
          await widget.device.lightControlCharacteristic.read();
      print(initializationValues);
      widget.device.extractInitializationValues(initializationValues);

      onWritePressed();
    } else {
      print("Initialized already");
    }
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.device.disconnectAndUpdateStream();
      print("Disconnect: Success");
    } catch (e) {
      print("Disconnect Error:");
    }
  }

  Future onDiscoverServicesPressed() async {
    setState(() {
      _isDiscoveringServices = true;
    });
    try {
      _services = await widget.device.device.discoverServices();
    } catch (e) {
      print("Discover Services Error:");
    }

    setState(() {
      _isDiscoveringServices = false;
    });

    widget.device.extractRelevantService();
    widget.device.extractLightControlCharacteristic();
    onInitialization();
  }

  void enableNotificationsForService(BluetoothService service) async {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      // Check if the characteristic supports notify
      if (characteristic.properties.notify) {
        // Enable notifications
        await characteristic.setNotifyValue(true);
      }
    }
  }

  void disableNotificationsForService(BluetoothService service) async {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      // Check if the characteristic supports notify
      if (characteristic.properties.notify) {
        // Enable notifications
        await characteristic.setNotifyValue(false);
      }
    }
  }

  Future onSubscribePressed() async {
    setState(() {
      _isSubscribing = !_isSubscribing;
    });
    try {
      _isSubscribing
          ? enableNotificationsForService(widget.device.service)
          : disableNotificationsForService(widget.device.service);
    } catch (e) {
      print("Error when subscribing");
    }
  }

  Widget buildConnectedDeviceTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''),
            style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        FilledButton.tonal(
          onPressed: onSubscribePressed,
          child: Text(_isSubscribing ? "Unsubscribe" : "Subscribe"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget brightnessSlider(BuildContext context) {
    return Opacity(
      opacity: widget.device.state == FixtureState.off ? 0.5 : 1.0,
      child: IgnorePointer(
        ignoring: widget.device.state == FixtureState.off,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  int newBrightness =
                      (widget.device.brightness - 5).clamp(0, 255);

                  setState(() {
                    widget.device.setBrightness(newBrightness);
                    onWritePressed();
                  });
                }),
            Expanded(
              child: Slider(
                value: widget.device.brightness.toDouble(),
                max: 255,
                divisions: 100,
                label: null,
                onChanged: (double value) {
                  int newBrightness = value.toInt().clamp(0, 255);

                  setState(() {
                    widget.device.setBrightness(newBrightness);
                  });
                },
                onChangeEnd: (double value) {
                  onWritePressed();
                },
              ),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  int newBrightness =
                      (widget.device.brightness + 5).clamp(0, 255);
                  setState(() {
                    widget.device.setBrightness(newBrightness);
                    onWritePressed();
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget brightnessSliderText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: widget.device.state == FixtureState.off ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: widget.device.state == FixtureState.off,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Brightness:  ',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: '${(widget.device.brightness * 0.392).round()}%',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (widget.device.state == FixtureState.on) {
                widget.device.setState(FixtureState.off);
              } else {
                widget.device.setState(FixtureState.on);
              }
              onWritePressed();
            });
          },
          icon: widget.device.state == FixtureState.on
              ? Icon(
                  Icons.toggle_on_outlined,
                  size: 50,
                )
              : Icon(
                  Icons.toggle_off_outlined,
                  size: 50,
                ),
        ),
      ],
    );
  }

  Widget buildBrightnessSlider(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          brightnessSliderText(context),
          brightnessSlider(context),
        ],
      ),
    );
  }

  Future onWritePressed() async {
    try {
      await widget.device.lightControlCharacteristic.write(
          widget.device.buildBluetoothMessage(),
          withoutResponse: widget.device.lightControlCharacteristic.properties
              .writeWithoutResponse);
      if (widget.device.lightControlCharacteristic.properties.read) {
        await widget.device.lightControlCharacteristic.read();
      }
    } catch (e) {
      print("Write Error:");
    }
  }

  ColorPicker buildColorPicker(BuildContext context) {
    return ColorPicker(
      // Use the screenPickerColor as start color.
      color: Color(widget.device.colorHex),
      // Update the screenPickerColor using the callback.
      onColorChanged: (Color color) {
        setState(
          () {
            screenPickerColor = color;
            //Set the color for the light fixture
            widget.device.setColor(color.value);
          },
        );
      },
      onColorChangeEnd: (Color color) {
        onWritePressed();
      },
      borderRadius: 4,
      spacing: 20,
      runSpacing: 20,
      wheelDiameter: 300,
      wheelWidth: 30,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      columnSpacing: 20,
      heading: null,
      subheading: null,
      wheelSubheading: null,
      colorCodeReadOnly: true,
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,

      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            disableNotificationsForService(widget.device.service);
            Navigator.of(context).pop();
          },
          child: Icon(
            size: 25,
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Text(widget.device.device.advName),
        titleTextStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: buildConnectedDeviceTile(context),
            title: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Device is ${_connectionState.toString().split('.')[1]}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ),
          SizedBox(height: 15),
          buildColorPicker(context),
        ],
      ),
      bottomSheet: buildBrightnessSlider(context),
    );
  }
}
