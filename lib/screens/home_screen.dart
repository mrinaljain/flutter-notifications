import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notification_course/services/local_notification.dart';
import 'package:notification_course/services/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    NotificationController.requestFirebaseToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Awesom Notifications Demo'),
      ),
      body: ListView(
        children: <Widget>[
          const ElevatedButton(
            onPressed: LocalNotification.scheduleNotification,
            child: Text(
              'Schedule notification',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                LocalNotification.showNotificationWithActionButtons(10),
            child: const Text(
              'Send Notification with action buttons',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                LocalNotification.showNotificationWithInputOptions(10),
            child: const Text(
              'Send Notification with input Options',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                LocalNotification.createBasicNotificationWithPayload(),
            child: const Text(
              'Send Notification with payload',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                LocalNotification.showIdeterminateProgressNotification(19),
            child: const Text(
              'Send Progress Notification with payload',
            ),
          ),
          ElevatedButton(
            onPressed: () => LocalNotification.showProgressbarNotification(3),
            child: const Text(
              'Send moving progress Notification ',
            ),
          ),
          ElevatedButton(
            onPressed: () => LocalNotification.createMessagingNotification(
              channelKey: 'chats',
              chatName: 'Emma Group',
              groupKey: 'Emma_group',
              message: 'Emma has send a message',
              userName: 'Emma',
              largeIcon: "asset://assets/images/profile.png",
            ),
            child: const Text(
              'Send Chat Notification',
            ),
          ),
          ElevatedButton(
            onPressed: () => LocalNotification.showEmojiNotification(25),
            child: const Text(
              'Show Emoji Notification',
            ),
          ),
          ElevatedButton(
            onPressed: () => LocalNotification.createWakeupNotification(33),
            child: const Text(
              'Show Wakeup Notification',
            ),
          ),
          ElevatedButton(
            onPressed: () => LocalNotification.cancelNotification(10),
            child: const Text(
              'Cancel Schedule notification',
            ),
          )
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: LocalNotification.sendNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
