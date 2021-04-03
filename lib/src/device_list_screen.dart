import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/device_list/device_list_cubit.dart';
import 'device_detail_screen.dart';
import 'models/bluetooth_device.dart';
import 'shared/animated_column.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "HYPERVOLT BLUETOOTH",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<DeviceListCubit, DeviceListState>(
          builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Builder(builder: (context) {
                  if (state.devices == null) {
                    return StaggeredAnimatedColumn(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WELCOME!',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Scan for available bluetooth devices.',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Tap the button below :-)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 100)
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 300),
                    child: StaggeredAnimatedColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (state.devices!.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No device found',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          else
                            ...state.devices!.map(
                              (device) => _BuildDeviceTile(device: device),
                            ),
                          if (state.isScanning)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                ),
                              ),
                            ),
                        ]),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: SafeArea(
                child: MaterialButton(
                  key: ObjectKey(state.isScanning),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16),
                      right: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.all(30),
                  minWidth: 240,
                  color: Colors.black,
                  onPressed: () {
                    if (state.isScanning) {
                      context.read<DeviceListCubit>().stopScan();
                    } else {
                      context
                          .read<DeviceListCubit>()
                          .startScan(const Duration(seconds: 5));
                    }
                  },
                  child: Text(
                    state.isScanning ? "STOP SCAN" : 'SCAN',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _BuildDeviceTile extends StatelessWidget {
  const _BuildDeviceTile({Key? key, required this.device}) : super(key: key);

  final HVBluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).pushNamed(DeviceDetailScreen.route,
            arguments: DeviceDetailScreenRouteArgument(device));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: Colors.black45,
            ),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (device.name.isNotEmpty)
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                if (device.name.isNotEmpty) const SizedBox(height: 10),
                const Text(
                  "MAC ADDRESS: ",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.macAddress,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                CupertinoIcons.chevron_forward,
              ),
            )
          ],
        ),
      ),
    );
  }
}
