import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ShopService {
  final String baseUrl = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = body
            .map((dynamic item) => ProductModel.fromJson(item))
            .toList();
        return products;
      } else {
        throw "Data CAnt Loaded";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
