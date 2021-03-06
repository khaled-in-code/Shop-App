import 'package:Shop_App/model/http_delete_exiption.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFavoriteValue(String authToken, String userId) async {
    final url =
        "https://flutter-testing-37474.firebaseio.com/userFavorite/$userId/$id/.json/?auth=$authToken";
    var oldFavoriteValu = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(url, body: json.encode(isFavorite));

    if (response.statusCode >= 400) {
      isFavorite = oldFavoriteValu;
      print("error is isFavorite method");
      notifyListeners();
      throw HttpExeption("changing favorite status error");
    }
  }
}
