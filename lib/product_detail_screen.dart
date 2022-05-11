import 'dart:ffi';

import 'package:digi_store_ui/models/special_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatelessWidget {
  SpecialOfferModel model;
  List<String> imgaeUrls = [];
  List<String> productTitles = [];
  List<String> productPrices = [];
  ProductDetailScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getDataFromPrefs();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text("جزئیات محصول"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.network(
                model.imageUrl!,
                fit: BoxFit.fill,
                height: 300,
                width: 300,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.productName!,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  model.offPrecent.toString() + "%",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.price.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.offPrice.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60)),
                    onPressed: () {},
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        saveDataToSP();
                      },
                      icon: Icon(Icons.shopping_basket),
                      label: Text(
                        'افزودن به سبد خرید',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    imgaeUrls = prefs.getStringList("imgaeUrls") ?? [];
    productTitles = prefs.getStringList("productTitles") ?? [];
    productPrices = prefs.getStringList("productPrices") ?? [];
    print(productTitles.length.toString());
  }

  Future<void> saveDataToSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    imgaeUrls.add(model.imageUrl!);
    productTitles.add(model.productName!);
    productPrices.add(model.offPrice.toString());
    prefs.setStringList("imgaeUrls", imgaeUrls);
    prefs.setStringList("productTitles", productTitles);
    prefs.setStringList("productPrices", productPrices);
  }
}
