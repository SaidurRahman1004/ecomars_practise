import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'cart_screen.dart'; // কার্ট স্ক্রিন ফাইলটি আমরা পরে বানাচ্ছি

class ShopScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController()); //DI
  ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gadget Store"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Get.to(() => CartScreen()),
              child: Center(
                child: Badge(
                  label: Obx(() => Text(controller.itemCount.toString())),
                  child: const Icon(Icons.shopping_cart, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.productList.length,
                itemBuilder: (context, index) {
                  final product = controller.productList[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      ),

                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Price: ৳${product.price}"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          controller.addToCart(product);
                        },
                        child: const Text("Add"),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
