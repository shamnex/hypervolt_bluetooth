import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/bluetooth_service.dart';
import '../../models/bluetooth_device.dart';

part 'device_list_state.dart';

class DeviceListCubit extends Cubit<DeviceListState> {
  final HVBlueToothService blueService;

  StreamSubscription<DeviceListState>? _subscription;
  DeviceListCubit(this.blueService)
      : super(const DeviceListState(
          isScanning: false,
        ));

  Future startScan(Duration duration) async {
    blueService.startScan();
    watch(duration);
  }

  Future stopScan() async {
    await blueService.stopScan();
    _subscription?.cancel();
    emit(DeviceListState(isScanning: false, devices: state.devices));
  }

  void watch(Duration duration) {
    _subscription?.cancel();
    Rx.combineLatest2<List<HVBluetoothDevice>, bool, DeviceListState>(
        blueService.watch(), blueService.isScanning(), (devices, isScanning) {
      log(devices.map((e) => e.macAddress).join("\n=========\n"));
      return DeviceListState(devices: devices, isScanning: isScanning);
    }).listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
