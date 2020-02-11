import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_ui_page.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';
import 'mqtt_stream.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

//
// This is added to route the logging info - which includes which file and where in the file
// the message came from.
//
  void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      final List<Frame> frames = Trace.current().frames;
      try {
        final Frame f = frames.skip(0).firstWhere((Frame f) =>
            f.library.toLowerCase().contains(rec.loggerName.toLowerCase()) &&
            f != frames.first);
        print(
            '${rec.level.name}: ${f.member} (${rec.loggerName}:${f.line}): ${rec.message}');
      } catch (e) {
        print(e.toString());
      }
    });
  }
  mqttSub(){
    print("mqttSub");
    subscribeAtBoot();
  }

void main() {
  initLogger();
  runApp(MyApp());
  mqttSub();      // Subscribe at boot
}

class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MqttPage(title: 'EspOledTemp'),
    );
  }
}
