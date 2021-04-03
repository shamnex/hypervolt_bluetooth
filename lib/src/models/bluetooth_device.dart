import 'package:equatable/equatable.dart';

class HVBluetoothDevice extends Equatable {
  final String name;
  final String macAddress;

  const HVBluetoothDevice({
    required this.name,
    required this.macAddress,
  });

  @override
  List<Object> get props => [name, macAddress];
}
