import 'dart:developer';

import 'package:flutter/material.dart';
import 'mqtt_stream.dart';
import 'Adafruit_feed.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

class MqttPage extends StatefulWidget {
  MqttPage({this.title});
  final String title;

  @override
  MqttPageState createState() => MqttPageState();
}

class MqttPageState extends State<MqttPage> {
  // Instantiate an instance of the class that handles
  // connecting, subscribing, publishing to Adafruit.io
  AppMqttTransactions myMqtt = AppMqttTransactions();
  final myTopicController = TextEditingController();
  final myValueController = TextEditingController();

  // Left panel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text("Header"),
              ),
              ListTile(
                title: Text("Home"),
              ),
              TextField(
                  controller: myTopicController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter topic to subscribe to',
                  ),
                ),
            ],
          ),
        ),
        body: _body(),
    );
  }

  //
  // The body of the page.  The children contain the main components of
  // the UI.
  Widget _body() {
    return Column(
      children: <Widget>[
        //_temp(),
        //_subscriptionInfo(),
        _subscriptionData(),
        //_senderIP(),

        // _publishInfo(),

      ],
    );
  }

  Widget _temp() {
    String reading;
    /*
    stream: MqttFeed.sensorStream;
    builder: (context, snapshot) {
      String reading = snapshot.data;
      return Text(reading); // = snapshot.data;
    };*/

    return Container(
        child:
          Text(reading.toString())
        //FlutterGauge(handSize: 30,width: 200,index: 25.0,fontFamily: "Iran",end: 100,number: Number.endAndCenterAndStart,secondsMarker: SecondsMarker.secondsAndMinute,counterStyle: TextStyle(color: Colors.black,fontSize: 25,)),

    );
  }


  Widget _subscriptionInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      child: Column(
        children:[
              Text(
                'Topic:',
                style: TextStyle(fontSize: 24),
              ),
              Text(

                  'Test',
                      style: TextStyle(fontSize: 24),
              ),
              /*
              TextField(
                  controller: myTopicController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    labelText: rec_topic,
                    hintText: rec_topic,
                  ),
                ),*/
              FlutterGauge(handSize: 30,width: 200,index: 25.0,fontFamily: "Iran",end: 100,number: Number.endAndCenterAndStart,secondsMarker: SecondsMarker.secondsAndMinute,counterStyle: TextStyle(color: Colors.black,fontSize: 25,)),
        ],

      ));
        //      Expanded(child: FlutterGauge(handSize: 30,width: 200,index: 25.0,fontFamily: "Iran",end: 100,number: Number.endAndCenterAndStart,secondsMarker: SecondsMarker.secondsAndMinute,counterStyle: TextStyle(color: Colors.black,fontSize: 25,)),),


  }

  // Define which data to show
  Widget _subscriptionData() {
    //return Text("reading");

    //MqttFeed.mqttStream.listen((value) {


/*
      print('Value from controller: $value');
      if (value.length!=0) {
        return value;
      }
      else {
        return "0";
      }
    });
*/

      return StreamBuilder(
        stream: MqttFeed.mqttStream,
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return CircularProgressIndicator();
          // }
          String reading = snapshot.data;
          if (reading == null) {
            return Text("Waiting");
          }
          var mData = reading.split(",");
          final mMap = mData.asMap(); // Convert to map
          var topic =  mData[0];
          var mess =  mData[1];

          if (topic == null) {
            topic = 'No topic yet';
          }
          if (mess == null) {
            mess = 'No message yet';
          }

          //return Text(reading);
          log(mess);

          return Container(
              child:
                Row(
                  children:[
                    Container(
                      child: Text(
                        'Topic: $topic ---',
                        style: TextStyle(fontSize: 12),

                      ),

                    ),
                    Text(
                      'Message: $mess',
                      style: TextStyle(fontSize: 12),

                    ),
                  ]
                )
          );





        });
  }
  /*
  Widget _senderIP(){
    return StreamBuilder(
        stream: MqttFeed.sensorStream,

        builder: (context, snapshot) {
          String reading = snapshot.data;

          String text='';
          if (reading == null) {
            reading = '---';
          }
          if (reading=="IP")
            {

            }
          reading = "Value: " + reading;
          return Text(reading);
        });
  }

   */
  Widget _publishInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Value:',
                style: TextStyle(fontSize: 24),
              ),
              // To use TextField within a row, it needs to be wrapped in a Flexible
              // widget.  See Stackoverflow: https://bit.ly/2IkzqBk
              Flexible(
                child: TextField(
                  controller: myValueController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter value to publish',
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Publish'),
            onPressed: () {
              publish(myTopicController.text, myValueController.text);
            },
          ),
        ],
      ),
    );
  }

  void subscribe(String topic) {
    myMqtt.subscribe(topic);
  }

  void publish(String topic, String value) {
    myMqtt.publish(topic, value);
  }
}

void test(){

  int favoriteCount = 1;
}


// void publish(String topic) {
// AppMqttTransactions mySubscribe = AppMqttTransactions();
// myPublish.publish(topic,3);
// }
