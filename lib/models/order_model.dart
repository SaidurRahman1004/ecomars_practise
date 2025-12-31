import 'package:cloud_firestore/cloud_firestore.dart';
class OrderModel {
  final String orderId;
  final String orderStatus;
  final DateTime timestamp;

  OrderModel({
    required this.orderId,
    required this.orderStatus,
    required this.timestamp,
  });
  
  //Receve Data From FireStore
  factory OrderModel.fromMap(Map<String, dynamic> fromJson){
    return OrderModel(
        orderId: fromJson['orderId'] ?? '',
        orderStatus: fromJson['orderStatus']?? '', 
        timestamp: (fromJson['timestamp'] as Timestamp).toDate(),
    );
  }
  
  //sent Data To FireStore convert Map to Json
  Map<String, dynamic> toMap(){
    return{
      'orderId': orderId,
      'orderStatus': orderStatus,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
