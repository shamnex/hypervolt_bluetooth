import '../models/bluetooth_device.dart';

abstract class HVBlueToothService {
  Future<void> stopScan();
  void startScan([Duration timeoutDuration]);
  Stream<bool> isScanning();
  Stream<List<HVBluetoothDevice>> watch();
}
