import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

import '../models/bluetooth_device.dart';
import 'bluetooth_service.dart';

class FlutterBlueService implements HVBlueToothService {
  final FlutterBlue _flutterBlue;

  FlutterBlueService(this._flutterBlue);

  @override
  Future<void> stopScan() {
    return _flutterBlue.stopScan();
  }

  @override
  Stream<bool> isScanning() {
    return _flutterBlue.isScanning;
  }

  @override
  void startScan([Duration timeoutDuration = const Duration(seconds: 5)]) {
    _flutterBlue.startScan(timeout: timeoutDuration);
  }

  @override
  Stream<List<HVBluetoothDevice>> watch() {
    return _mapScanResultToHVBluetoothDevice(_flutterBlue.scanResults)
        .startWith([]);
  }

  Stream<List<HVBluetoothDevice>> _mapScanResultToHVBluetoothDevice(
      Stream<List<ScanResult>> scanResults) {
    return _flutterBlue.scanResults.map((scanResults) {
      return scanResults
          .map(
            (result) => HVBluetoothDevice(
              name: result.device.name.isEmpty
                  ? result.advertisementData.localName
                  : result.device.name,
              macAddress: result.device.id.id,
            ),
          )
          .toList();
    });
  }
}
