import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _batteryPercentage = 'Bateria';
  String _datePhone = 'Hora';

  @override
  initState(){
    _getBatteryInformation();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _getDateInformation();
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text(
            _batteryPercentage + " \n " + _datePhone,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ]),
    );
  }

  static const batteryChannel = const MethodChannel('battery');
  static const dateChannel = const MethodChannel('date');

  Future<void> _getBatteryInformation() async {
    String batteryPercentage;
    try {
      var result = await batteryChannel.invokeMethod('getBatteryLevel');
      batteryPercentage = 'Bateria = $result%';
    } on PlatformException catch (e) {
      batteryPercentage = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryPercentage = batteryPercentage;
    });
  }

  Future<void> _getDateInformation() async {
    String datePhone;
    try {
      var result = await dateChannel.invokeMethod('getDate');
      datePhone = 'Hora = $result';
    } on PlatformException catch (e) {
      datePhone = "Failed date: '${e.message}'.";
    }
    setState(() {
      _datePhone = datePhone;
    });
  }
}
