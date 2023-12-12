import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PairedDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onOpen;
  final VoidCallback onConnect;
  final VoidCallback onDelete;
  final VoidCallback onDisconnect;

  const PairedDeviceTile({
    required this.device,
    required this.onOpen,
    required this.onConnect,
    required this.onDisconnect,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<PairedDeviceTile> createState() => _PairedDeviceTileState();
}

class _PairedDeviceTileState extends State<PairedDeviceTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        title: Text(widget.device.platformName),
        subtitle:
            isConnected ? const Text('Connected') : const Text('Disconnected'),
        onTap: isConnected ? widget.onOpen : widget.onConnect,
        onLongPress: widget.onDelete,
        leading: isConnected
            ? Icon(Icons.lightbulb)
            : Icon(Icons.lightbulb_outlined),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isConnected
                ? IconButton.outlined(
                    onPressed: () {
                      widget.onDisconnect();
                    },
                    icon: Icon(
                      Icons.power_off_outlined,
                      size: 30,
                    ))
                : IconButton.outlined(
                    onPressed: () {
                      widget.onConnect();
                    },
                    icon: Icon(
                      Icons.power_outlined,
                      size: 30,
                    ))
          ],
        ),
      ),
    );
  }
}
