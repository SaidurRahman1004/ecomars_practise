import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomars_practise/main.dart';
import 'package:ecomars_practise/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/order_model.dart';

class OrderService {
  //Instance of FireStore and Local Notification Plugin
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Init Local Notification Plugin
  Future<void> initLocalNotifications() async {
    //settings for android
    final AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //Settings for all platforms
    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );
    //// Plugin Initialize
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification Clicked ${response.payload}');
        // Handle Notification Click
        handleNotificationClick(response.payload);
      },
    );
  }

  //FireStore Status Update And sent Notifications
  Future<void> updateOrderStatus(String orderId, String status) async {
    //create New Order Model OBject
    final OrderModel order = OrderModel(
      orderId: orderId,
      orderStatus: status,
      timestamp: DateTime.now(),
    );
    //Save data to Firebase
    await _firestore
        .collection('orders')
        .doc(orderId)
        .set(order.toMap(), SetOptions(merge: true));

    //Sent Local Notificions //Notification Message Create
    String title = '';
    String body = 'Your $orderId has been Updated';
    String icon = '';
    if (status == 'Placed') {
      title = '📦 Order Placed';
      body = 'Your $orderId has been confirmed';
    } else if (status == 'Shipped') {
      title = '🚚 Order Shipped';
      body = 'Your order #$orderId is on the way.';
    } else if (status == "Delivered") {
      title = "✅ Order Delivered!";
      body = "Your order #$orderId has arrived.";
    }

    //Show Notification
    _showNotification(title, body, '$orderId|$status');
  }

  //Show Notification
  Future<void> _showNotification(
    String title,
    String body,
    String payload,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'order_channel',
          'Order Update',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      notificationDetails,
      payload: payload, //Click this payload for pass
    );
  }

  //Handle Notifications Click
  Future<void> handleNotificationClick(String? payload) async {
    if (payload == null) return;
    final parts = payload.split('|');
    final orderId = parts[0];
    final status = parts[1];

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(orderId: orderId, status: status),
      ),
    );
  }
}
