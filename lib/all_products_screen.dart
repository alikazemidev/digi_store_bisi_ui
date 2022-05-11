import 'package:digi_store_ui/apiUrl.dart';

import 'package:digi_store_ui/product_detail_screen.dart';
import 'package:digi_store_ui/widgets/bottom_nav.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'models/special_offer_model.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  bool isGridTwo = true;
  Future<List<SpecialOfferModel>>? futureSpecial;
// *offer product
  Future<List<SpecialOfferModel>> sendRequestSpecialOffer() async {
    List<SpecialOfferModel> specialModels = [];
    var response = await Dio().get(offerProductAPI);
    for (var item in response.data['products']) {
      specialModels.add(
        SpecialOfferModel(
          id: item['id'],
          imageUrl: item['imageUrl'],
          offPrecent: item['off_precent'],
          offPrice: item['off_price'],
          price: item['price'],
          productName: item['product_name'],
        ),
      );
    }

    return specialModels;
  }

  @override
  void initState() {
    super.initState();
    futureSpecial = sendRequestSpecialOffer();
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
        actions: [
          IconButton(
            onPressed: () {
              isGridTwo = !isGridTwo;
              setState(() {});
            },
            icon: Icon(Icons.table_chart_rounded),
          ),
        
        ],
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text("فروشگاه"),
      ),
      body: Container(
        child: FutureBuilder<List<SpecialOfferModel>>(
          future: futureSpecial,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final model = snapshot.data!;
              return GridView.count(
                crossAxisCount: isGridTwo ? 2 : 3,
                children: List.generate(
                  snapshot.data!.length,
                  (index) {
                    return genrateItem(model[index]);
                  },
                ),
              );
            } else {
              return Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 60,
                  dotSpacing: 5,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  InkWell genrateItem(SpecialOfferModel model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(model: model),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            isGridTwo
                ? Positioned(
                    top: 0,
                    left: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          model.offPrecent.toString() + "%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        model.imageUrl!,
                      ),
                    ),
                    isGridTwo
                        ? Column(
                            children: [
                              Text(model.productName!),
                              Text(model.offPrice!.toString()),
                              Text(
                                model.price!.toString(),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
