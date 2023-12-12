import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lumos_app/components/connected_device_tile.dart';
import 'package:lumos_app/components/extra.dart';
import 'package:lumos_app/models/light_fixture_model.dart';
import 'package:lumos_app/pages/page_light_fixture.dart';
import 'package:provider/provider.dart';
import '../models/device_list.dart';

import 'page_new_fixture.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onTap(Device device) {
    if (device.deviceType == DeviceType.lightFixture) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LightFixturePage(
            device: device as LightFixtureModel,
          ),
        ),
      );
    } else {
      // Handle other device types or provide an error message.
      print("Device is not a LightFixture");
    }
  }

  void onConnectedPressed(BluetoothDevice device) {
    device.connectAndUpdateStream();
    print("connecting");
    setState(() {});
  }

  void onDisconnectPressed(BluetoothDevice device) {
    device.disconnectAndUpdateStream();
    print("disconnecting");
    setState(() {});
  }

  void onDelete(BluetoothDevice device) {
    device.disconnectAndUpdateStream();
    Provider.of<DeviceList>(context, listen: false)
        .removeDevice(device, DeviceType.lightFixture);
    setState(() {});
  }

  Widget buildDeleteAlertDialog(BuildContext context, BluetoothDevice device) {
    return AlertDialog(
      title: null,
      content: Text(
        "Would you like to delete this device?",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        OutlinedButton(
            onPressed: () {
              onDelete(device);
              Navigator.of(context).pop();
            },
            child: Text(
              "Yes",
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    );
  }

  Future<void> showDeleteAlertDialog(BluetoothDevice device) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildDeleteAlertDialog(context, device);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceList>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const NewFixturePage(),
              ),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.list,
                  size: 30,
                ),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: Column(
                  children: [
                    Text('PixLED Application',
                        style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(
                      height: 20,
                    ),
                    Text("version: 0.0.1",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView.builder(
            itemCount: value.devices.length,
            itemBuilder: (context, index) {
              //Get individual fixture
              Device d = value.devices[index];

              return PairedDeviceTile(
                device: d.device,
                onOpen: () => onTap(d),
                onConnect: () => onConnectedPressed(d.device),
                onDisconnect: () => onDisconnectPressed(d.device),
                onDelete: () => showDeleteAlertDialog(d.device),
              );
            },
          ),
        ),
      ),
    );
  }
}
