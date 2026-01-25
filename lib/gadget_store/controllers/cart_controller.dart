import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/shop_service.dart';

class CartController extends GetxController {
  var productList = <ProductModel>[].obs;
  var cartItems = <ProductModel>[].obs;
  final ShopService _shopService = ShopService();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // load
  Future<void> fetchProducts() async {
    var products = await _shopService.fetchProducts();
    productList.assignAll( products);
  }

  // add
  void addToCart(ProductModel product) {
    cartItems.add(product);
    Get.snackbar(
      "Added to Cart",
      "${product.name} added successfully!",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // remove
  void removeFromCart(ProductModel product) {
    cartItems.remove(product);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  // cart Item List
  int get itemCount => cartItems.length;
}