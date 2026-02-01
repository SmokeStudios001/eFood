import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/models/notification_body.dart';
import 'package:resturant_delivery_boy/common/models/notification_payload_model.dart';
import 'package:resturant_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:resturant_delivery_boy/features/maintenance/screens/maintenance_screen.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/features/chat/providers/chat_provider.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/features/order/screens/order_details_screen.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);


    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {

        int? orderId;
        orderId = int.tryParse(notificationResponse.payload!);
        try{
          if(orderId != null) {
            Get.navigator!.push(MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: orderId)));
          }
        }catch (e) {
          debugPrint('error ---${e.toString()}');
        }
        return;
      },);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{

      final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);

      if(message.data['type'] == 'maintenance'){
        await splashProvider.initConfig(Get.context!);
        if(splashProvider.configModel?.maintenanceMode?.maintenanceStatus == 1 && splashProvider.configModel?.maintenanceMode?.selectedMaintenanceSystem?.customerApp == 1) {
          Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MaintenanceScreen()), (route) => false);
        }
        if(splashProvider.configModel?.maintenanceMode?.maintenanceStatus == 0){
          Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
        }
      }
      if(message.data['type'] == 'message') {
        int? id;
        id = int.tryParse('${message.data['order_id']}');
        Provider.of<ChatProvider>(Get.context!, listen: false).getChatMessages(id);
      }

      if(message.data['type'] != 'maintenance'){
        showNotification(message, flutterLocalNotificationsPlugin);
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{

      final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);

      if(message.data['type'] == 'maintenance'){
        await splashProvider.initConfig(Get.context!);
        if(splashProvider.configModel?.maintenanceMode?.maintenanceStatus == 1 && splashProvider.configModel?.maintenanceMode?.selectedMaintenanceSystem?.customerApp == 1) {
          Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MaintenanceScreen()), (route) => false);
        }
        if(splashProvider.configModel?.maintenanceMode?.maintenanceStatus == 0){
          Navigator.of(Get.context!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
        }
      }

      int? orderId = int.tryParse('${message.data['order_id']}');
      if(orderId != null) {
        if(message.data['type'] == 'message'){
          Provider.of<ChatProvider>(Get.context!, listen: false).getChatMessages(orderId);
        }
        Get.navigator!.push(MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: orderId)));
      }

    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin? fln) async {
    String? title;
    String? body;
    String? orderID;
    String? image;

    title = message.data['title'];
    body = message.data['body'];
    orderID = message.data['order_id'];
    image = (message.data['image'] != null && message.data['image'].isNotEmpty)
        ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

    if(image != null && image.isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln!);
      }catch(e) {
        await showBigTextNotification(title, body!, orderID, fln!);
      }
    }else {
      await showBigTextNotification(title, body!, orderID, fln!);
    }
  }


  static Future<void> showBigTextNotification(String? title, String body, String? orderID, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', 'efood', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, String? orderID, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', 'efood',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data){
    return NotificationBody.fromJson(data);
  }

}



@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {

  NotificationPayloadModel payloadModel = NotificationPayloadModel.fromJson(message.data);

  if(payloadModel.isAssignedNotification ?? false) {

    FlutterForegroundTask.initCommunicationPort();

    _initService();

    await _startService(payloadModel.orderId);

  }


}




@pragma('vm:entry-point')
Future<ServiceRequestResult> _startService(String? orderId) async {
  if (await FlutterForegroundTask.isRunningService) {
    return FlutterForegroundTask.restartService();

  } else {

    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'You got a new order ($orderId)',
      notificationText: 'Open app and check order details.',
      callback: startCallback,
    );
  }
}

@pragma('vm:entry-point')
void _initService() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'eFood',
      channelName: 'Foreground Service Notification',
      channelDescription:
      'This notification appears when the foreground service is running.',
      onlyAlertOnce: false,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: false,
      autoRunOnMyPackageReplaced: false,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

// @pragma('vm:entry-point')
Future<ServiceRequestResult> stopService() async {
  try{
    _audioPlayer.dispose();

  }catch(e) {
    debugPrint('error-----$e');
  }
  return FlutterForegroundTask.stopService();
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

final AudioPlayer _audioPlayer = AudioPlayer();

class MyTaskHandler extends TaskHandler {

  void _playAudio(){
    _audioPlayer.play(AssetSource('notification.mp3'));
  }
  // void _incrementCount() {
  //
  //   // Update notification content.
  //   FlutterForegroundTask.updateService(
  //     notificationTitle: 'Hello MyTaskHandler :)',
  //     notificationText: 'count: ',
  //   );
  //
  //   // Send data to main isolate.
  //   FlutterForegroundTask.sendDataToMain(1);
  // }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _playAudio();
  }

  // Called by eventAction in [ForegroundTaskOptions].
  // - nothing() : Not use onRepeatEvent callback.
  // - once() : Call onRepeatEvent only once.
  // - repeat(interval) : Call onRepeatEvent at milliseconds interval.
  @override
  void onRepeatEvent(DateTime timestamp) {
    _playAudio();

  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    stopService();
  }
  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  @override
  void onReceiveData(Object data) {
    _playAudio();
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    if(id == '0') {
      FlutterForegroundTask.launchApp('/');
    }
    stopService();
  }

  // Called when the notification itself is pressed.
  //
  // AOS: "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted
  // for this function to be called.
  @override
  void onNotificationPressed() {

    FlutterForegroundTask.launchApp('/');
    stopService();
  }

  // Called when the notification itself is dismissed.
  //
  // AOS: only work Android 14+
  // iOS: only work iOS 10+
  @override
  void onNotificationDismissed() {
      FlutterForegroundTask.updateService(
        notificationTitle: 'You got a new order!',
        notificationText: 'Open app and check order details.',
      );
  }


}
