import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(
    new MaterialApp(home: new MyApp()),
  );
}
class MyApp extends StatefulWidget {
  @override
  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
   
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Notification example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new SizedBox(
                height: 30.0,
              ),
              new RaisedButton(
                onPressed: _showNotificationWithDefaultSound,
                child: new Text('Show Notification On Button Click'),
              ),
              new SizedBox(
                height: 30.0,
              ),

              FlatButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      scheuleAtParticularTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              date.millisecondsSinceEpoch));
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Select time for notification arrival',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  )),
            ],
          ),
        ),
      ),
    );
  }
   Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(

        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Learn Local Notification',
      'A Local Notification On Button Click',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
  Future scheuleAtParticularTime(DateTime timee) async {
    var time = Time(timee.hour, timee.minute, timee.second);
    print(time.toString());
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.showDailyAtTime(0, 'show daily title',
        'Daily notification shown', time, platformChannelSpecifics);
    print('scheduled');
    Fluttertoast.showToast(
        msg:
            "Notification Scheduled for ${time.hour} : ${time.minute} : ${time.second}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // also possible "TOP" and "CENTER"
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }
  }
