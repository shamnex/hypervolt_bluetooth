import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'src/blocs/device_list/device_list_cubit.dart';
import 'src/device_detail_screen.dart';
import 'src/device_list_screen.dart';
import 'src/infrastructure/flutter_blue_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterBlue = FlutterBlue.instance;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceListCubit(FlutterBlueService(_flutterBlue)),
      child: MaterialApp(
        title: 'HYPERVOLT BLUETOOTH',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(builder: (context) {
            if (settings.name == DeviceDetailScreen.route) {
              final argument =
                  settings.arguments as DeviceDetailScreenRouteArgument?;

              return DeviceDetailScreen(
                device: argument!.device,
              );
            }
            return const DeviceListScreen();
          });
        },
      ),
    );
  }
}
