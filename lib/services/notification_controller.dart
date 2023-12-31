import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_course/firebase_options.dart';
import 'package:notification_course/main.dart';
import 'package:notification_course/screens/notification_screen.dart';
import 'package:notification_course/services/local_notification.dart';

navigatorHelper(ReceivedAction receivedAction) {
  // this function will check th e payload inside the notification and perform navigations accordingly
  if (receivedAction.payload != null &&
      receivedAction.payload!['screen_name'] == 'notification_screen') {
    Navigator.push(
      MyApp.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }
}

Future<void> _bgMessageHandler(RemoteMessage remoteMessage) async {
  print("Background Message ${remoteMessage.toMap()}");
}

class NotificationController with ChangeNotifier {
  // SINGELTON PATTERN
  static final NotificationController _instance =
      NotificationController._internal();
  factory NotificationController() {
    return _instance;
  }
  NotificationController._internal();

  // INITIALIZATION METHOD
  static Future<void> initializeLocalNotification({required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notification',
          channelDescription: 'Notification Channel for basic Testing',
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          defaultPrivacy: NotificationPrivacy.Public,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          defaultColor: Colors.greenAccent,
          enableLights: true,
          icon: 'resource://drawable/res_naruto',
          playSound: true,
          soundSource: 'resource://raw/naruto_jutsu',
        ),
        NotificationChannel(
          channelGroupKey: 'chat_tests',
          channelKey: 'chats',
          channelName: 'Group Chats',
          channelDescription: 'Notification Channel for group Chats',
          importance: NotificationImportance.Max,
        )
      ],
      debug: debug,
      languageCode: 'En',
    );
  }

  // INITILIZE REMOTE NOTIFICATION
  static Future<void> initializeRemoteNotification({
    required bool debug,
  }) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AwesomeNotificationsFcm().initialize(
      onFcmTokenHandle: NotificationController.myFcmTokenHandle,
      onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
      onNativeTokenHandle: NotificationController.myNativeTokenHandle,
      licenseKeys: [],
      debug: debug,
    );
  }

  // INITILIZE REMOTE NOTIFICATION via FIREBASE Messaging
  static Future<void> initializeFirebaseRemoteNotification({
    required bool debug,
  }) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// This will run when the message comes in BACKGROUND or TERMINATED state
    FirebaseMessaging.onBackgroundMessage(_bgMessageHandler);

    /// This will listen to the notification when the app is in FOREGROUND
    FirebaseMessaging.onMessage.listen(NotificationController.onMessageListner);

    FirebaseMessaging.onMessageOpenedApp
        .listen(NotificationController.onMessageOppenedAppListner);
  }

  static onMessageListner(RemoteMessage remoteMessage) {
    print("onMessage Recived FOREGROUND ${remoteMessage.toMap()}");
  }

  static onMessageOppenedAppListner(RemoteMessage remoteMessage) {
    print("onMessageOpendApp Recived BACKGROUND ${remoteMessage.toMap()}");
  }

  static Future<void> getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('Firebase FCM ${fcmToken}');
  }

  // EVENT LISTNERS
  static Future<void> initializeNotificationEventListners() async {
    // Only after atleast the action method is set, the notification events are
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  // This works when User interacts with the Notification
  static Future<void> onActionReceivedMethod(
    ReceivedAction recivedAction,
  ) async {
    bool isSilentAction = recivedAction.actionType == ActionType.SilentAction ||
        recivedAction.actionType == ActionType.SilentBackgroundAction;

    debugPrint(
        "${isSilentAction ? 'Silent Action' : 'Normal Action'}  Notification Recived");
    print('Recived Action : ${recivedAction.toString()}');
    if (recivedAction.channelKey == 'chats') {
      reciveChatNotificationAction(recivedAction);
    } else {
      navigatorHelper(recivedAction);
    }

    switch (recivedAction.buttonKeyPressed) {
      case 'SUBSCRIBE':
        print('Subscribe Now Action Button pressed');
        break;
      case 'DISMISS':
        print('Dismiss Action Button pressed');
        break;
      case 'OPEN_PROFILE':
        navigatorHelper(recivedAction);
      default:
    }
    Fluttertoast.showToast(
      msg:
          "${isSilentAction ? 'Silent Action' : 'Normal Action'}  Notification Recived",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // This works when ever we create a Notification
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification recivedNotification,
  ) async {
    debugPrint("Notification Created");

    Fluttertoast.showToast(
      msg: "Notification Created",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // This works when Ever Notification is Displayed to User
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification recivedNotification,
  ) async {
    debugPrint("Notification Displayed");
    print('Recived Notification : ${recivedNotification.toString()}');
    Fluttertoast.showToast(
      msg: "Notification Displayed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // This works when User interacts with the Notification Dismis Action Button
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction recivedAction,
  ) async {
    debugPrint("Notification Dismissed");

    Fluttertoast.showToast(
      msg: "Notification Dismissed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // This method will return the initial notification action if the application
  // is opened from a notification or terminated state
  // Gets the notification action that launched the app, if any.
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction != null) {
      print('Initial Action : ${receivedAction.toString()}');
      navigatorHelper(receivedAction);
    }
  }

  static Future<void> reciveChatNotificationAction(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case 'REPLY':
        await LocalNotification.createMessagingNotification(
          channelKey: 'chats',
          groupKey: receivedAction.groupKey!,
          chatName: receivedAction.summary!,
          userName: 'You',
          largeIcon: "",
          message: receivedAction.buttonKeyInput,
        );
        break;
      default:
    }
  }

  /// Remote Notifications Event Listners

  /// Use this method to execute on background when a silent data arrives
  /// (even while app is terminated)
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    Fluttertoast.showToast(
      msg: "Silent Data Recived",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print('SilentData : ${silentData.data}');

    if (silentData.data!['IsLiveScore'] == "true") {
      LocalNotification.createLiveScoreNotification(
        id: 1,
        title: silentData.data!['title']!,
        body: silentData.data!['body']!,
        largeIcon: silentData.data!['largeIcon'],
      );
    }
    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
      print('FOREGROUND');
    } else {
      print('BACKGROUND');
    }
  }

  /// Use this method to execute on background when a fcm token arrives
  static Future<void> myFcmTokenHandle(String token) async {
    Fluttertoast.showToast(
      msg: "FCM Token Recived",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print('FCM Token : $token');
  }

  /// Use this method to execute on background when a native token arrives
  static Future<void> myNativeTokenHandle(String token) async {
    Fluttertoast.showToast(
      msg: "Native Token Recived",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print('Native Token : $token');
  }

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        var fcmToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
        print('FCM TOKEN $fcmToken');
        return fcmToken;
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available for this project');
    }
    return '';
  }

  static Future<void> subscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    print('Subscribe to $topic');
  }

  static Future<void> unSubscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().unsubscribeToTopic(topic);
    print('UnSubscribe to $topic');
  }
}
