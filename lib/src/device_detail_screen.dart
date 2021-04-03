import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/bluetooth_device.dart';
import 'shared/animated_column.dart';

class DeviceDetailScreenRouteArgument {
  final HVBluetoothDevice device;

  DeviceDetailScreenRouteArgument(this.device);
}

class DeviceDetailScreen extends StatelessWidget {
  static const String route = "DeviceDetailScreen";
  final HVBluetoothDevice device;
  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            device.name.isNotEmpty ? device.name : "BLUETOOTH DEVICE",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StaggeredAnimatedColumn(
            direction: StaggeredAnimatedDirection.horizontal,
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1000),
            children: [
              ...List.generate(4, (index) => const SizedBox()),
              const SizedBox(height: 30),
              if (device.name.isNotEmpty)
                Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(height: 10),
              const Text(
                "MAC ADDRESS",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  device.macAddress,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
