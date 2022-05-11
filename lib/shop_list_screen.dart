import 'dart:async';

import 'package:digi_store_ui/models/shop_list_model.dart';
import 'package:digi_store_ui/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({Key? key}) : super(key: key);

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  StreamController<ShopListModel> streamController = StreamController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromPrefs();
  }

  Future<void> getDataFromPrefs() async {
    List<String> imgaeUrls = [];
    List<String> productTitles = [];
    List<String> productPrices = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    imgaeUrls = prefs.getStringList("imgaeUrls") ?? [];
    productTitles = prefs.getStringList("productTitles") ?? [];
    productPrices = prefs.getStringList("productPrices") ?? [];

    var model = ShopListModel(
      imgaeUrls: imgaeUrls,
      productPrices: productPrices,
      productTitles: productTitles,
    );
    streamController.add(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNav(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text('لیست خرید'),
      ),
      body: Container(
        child: StreamBuilder<ShopListModel>(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.imgaeUrls!.length,
                itemBuilder: (context, index) {
                  return genrateItem(
                    context,
                    snapshot.data!.imgaeUrls![index],
                    snapshot.data!.productTitles![index],
                    snapshot.data!.productPrices![index],
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Card genrateItem(
    BuildContext context, String imageUrl, String prodTitle, String prodPrice) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        20,
      ),
    ),
    elevation: 20,
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(prodTitle),
                      Text(prodPrice),
                    ],
                  ),
                ),
              ),
              Image.network(imageUrl),
            ],
          ),
        ),
      ),
    ),
  );
}
