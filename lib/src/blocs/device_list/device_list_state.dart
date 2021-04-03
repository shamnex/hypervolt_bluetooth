part of 'device_list_cubit.dart';

@immutable
class DeviceListState extends Equatable {
  final List<HVBluetoothDevice>? devices;
  final bool isScanning;

  const DeviceListState({
    required this.isScanning,
    this.devices,
  });

  @override
  List<Object> get props => [
        if (devices != null) devices!,
        isScanning,
      ];
}
