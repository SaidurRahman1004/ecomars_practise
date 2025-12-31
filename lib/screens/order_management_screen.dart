import 'package:ecomars_practise/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../services/order_services.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final OrderService _orderService = OrderService();
  final String orderId = '123456789';
  @override
  void initState() {
    super.initState();
    _orderService.initLocalNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                _buildContainer('Order ID', orderId),
                const SizedBox(height: 40,),
                _buildContainer('Current Status', orderId),
                const SizedBox(height: 40,),
                CustomButton(buttonName: ' Place Order', onPressed: () async{
                  _orderService.updateOrderStatus(orderId, 'Placed');
                },icon: Icons.inventory,),
                const SizedBox(height: 20,),
                CustomButton(buttonName: ' Ship Order', onPressed: () async{
                  _orderService.updateOrderStatus(orderId, 'Shipped');
                },color: Colors.blueAccent,icon: Icons.delivery_dining,),
                const SizedBox(height: 20,),
                CustomButton(buttonName: ' Deliver Order', onPressed: () async{
                  _orderService.updateOrderStatus(orderId, 'Delivered');
                },color: Colors.amber,icon: Icons.check_circle_outline,),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(String title,String text){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,

          )
      ),
      child: Column(
        children: [
          Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
          const SizedBox(height: 10,),
          Text(text,style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ),
    );

  }
}
