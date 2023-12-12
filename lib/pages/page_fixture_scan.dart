import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lumos_app/models/device_list.dart';
import 'package:lumos_app/components/scan_result_tile.dart';
import 'package:lumos_app/models/light_fixture_model.dart';
import 'dart:async';
import '../components/extra.dart';
import 'package:provider/provider.dart';

class FixtureScanPage extends StatefulWidget {
  const FixtureScanPage({super.key});

  @override
  State<FixtureScanPage> createState() => _FixtureScanPageState();
}

class _FixtureScanPageState extends State<FixtureScanPage> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      setState(() {});
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    } catch (e) {
      print("Start Scan Error:");
    }
    setState(() {}); // force refresh of systemDevices
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      print("Stop Scan Error:");
    }
  }

  Future onConnectPressed(ScanResult scanDevice) async {
    try {
      scanDevice.device.connectAndUpdateStream().catchError((e) {
        print("Connect Error:");
      });
      //TODO: verify if the avertissement data service uuids to determine
      // which type of device it is and add the corresponding fixture.
      Provider.of<DeviceList>(context, listen: false)
          .addDevice(scanDevice.device, DeviceType.lightFixture);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error during connection to the device");
    }
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    setState(() {});
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
        onPressed: onScanPressed,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: const Text("SCAN"),
      );
    }
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .where((r) => r.advertisementData.advName.contains("BLE") == true)
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () {
              onConnectPressed(r);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceList>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Find your fixture'),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              ..._buildScanResultTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }
}
