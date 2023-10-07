import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

int createUniqueID(int maxValue) {
  Random random = Random();
  int randomNumber = random.nextInt(maxValue);
  return randomNumber;
}

class LocalNotification {
  // SINGELTON PATTERN
  static final LocalNotification _instance = LocalNotification._internal();

  factory LocalNotification() {
    return _instance;
  }
  LocalNotification._internal();

  static void scheduleNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Simple Notification',
        body: 'Simple Notification body',
        bigPicture: 'https://picsum.photos/200/300',
        notificationLayout: NotificationLayout.BigPicture,
      ),
      // For time intervals
      schedule: NotificationCalendar(
        // weekday:1,
        // hour: 8,
        // minute: 55,
        second: 0,
        repeats: true,
      ),
      // for specific time interval
      // schedule: NotificationCalendar.fromDate(
      //   date: DateTime.now().add(
      //     const Duration(seconds: 30),
      //   ),
      //   allowWhileIdle: true,
      //   repeats: true,
      //   preciseAlarm: true,
      // ),
    );
  }

  static void sendNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Simple Notification',
        body: 'Simple Notification body',
        bigPicture: 'https://picsum.photos/200/300',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  static Future<void> showNotificationWithActionButtons(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple Notification body',
        ),
        actionButtons: [
          // NotificationActionButton(
          //   key: 'READ',
          //   label: 'Mark as Read',
          //   autoDismissible: true,
          // ),
          NotificationActionButton(
            key: 'SUBSCRIBE',
            label: 'Subscribe',
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.SilentAction,
            // autoDismissible: true,
            // isDangerousOption: true,
            enabled: true,
            color: Colors.green,
          ),
        ]);
  }

  static Future<void> showNotificationWithInputOptions(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple Notification body',
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'READ',
            label: 'Reply',
            requireInputText: true,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.Default,
            autoDismissible: true,
            // isDangerousOption: true,
            enabled: false,
            color: Colors.green,
          ),
        ]);
  }

  static Future<void> createBasicNotificationWithPayload() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Press to go on NotificationScreen',
          payload: {'screen_name': 'notification_screen'}),
    );
  }

  //CHAT NOTIFICATION
  static Future<void> createMessagingNotification({
    required String channelKey,
    required String groupKey,
    required String chatName,
    required String userName,
    required String message,
    String? largeIcon,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueID(AwesomeNotifications.maxID),
        groupKey: groupKey,
        channelKey: channelKey,
        summary: chatName,
        title: userName,
        body: message,
        largeIcon: largeIcon,
        notificationLayout: NotificationLayout.MessagingGroup,
        category: NotificationCategory.Message,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: 'Reply',
          requireInputText: true,
          autoDismissible: false,
        ),
        NotificationActionButton(
          key: 'READ',
          label: 'Mark as Read',
          autoDismissible: true,
        )
      ],
    );
  }

  static Future<void> showIdeterminateProgressNotification(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: 'Downloadein Fake profile',
      body: 'Simple Notification body',
      category: NotificationCategory.Progress,
      notificationLayout: NotificationLayout.ProgressBar,
      progress: null,
      payload: {'file': 'filename.txt'},
      locked: true,
    ));
    await Future.delayed(const Duration(seconds: 5));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: 'Download Complete',
      body: 'filename.txt',
      category: NotificationCategory.Progress,
      locked: false,
    ));
  }

  static int currentStep = 0;

  /// Create Progressbar updating notification
  static Future<void> showProgressbarNotification(int id) async {
    int maxStep = 10;
    for (var simulatedStep = 1; simulatedStep <= maxStep; simulatedStep++) {
      currentStep = simulatedStep;
      await Future.delayed(const Duration(seconds: 1));
      _updateCurrentProgressBar(
          id: id, simulatedStep: currentStep, maxStep: maxStep);
    }
  }

  // The trick to create the progress notification is to create new notification
  // with the same id and  updated progress data
  static void _updateCurrentProgressBar({
    required int id,
    required int simulatedStep,
    required int maxStep,
  }) {
    if (simulatedStep > maxStep) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Download Complete',
          body: 'filename.txt',
          category: NotificationCategory.Progress,
          payload: {'file': 'filename.txt'},
          locked: false,
        ),
      );
    } else {
      int progress = min((simulatedStep / maxStep * 100).round(), 100);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Downloading File in progress($progress%)',
          body: 'filename.txt',
          category: NotificationCategory.Progress,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress,
          payload: {'file': 'filename.txt'},
          locked: true,
        ),
      );
    }
  }

  // Create Emoji Notification
  static Future<void> showEmojiNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Simple Emoji Notification 😎',
        body: 'Body of Emoji Notification',
      ),
    );
  }

  // Create Wakeup Notification
  static Future<void> createWakeupNotification(int id) async {
    await Future.delayed(const Duration(seconds: 10));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Simple Wakeup Notification 😎',
        body: 'Body of Emoji Notification',
        wakeUpScreen: true,
      ),
    );
  }

  static void cancelNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}
