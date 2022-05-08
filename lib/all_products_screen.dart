import 'package:digi_store_ui/apiUrl.dart';
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
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text("فروشگاه"),
      ),
      body: Container(
        child: FutureBuilder<List<SpecialOfferModel>>(
          future: futureSpecial,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data!.length,
                  (index) {
                    return Card(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
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
                                  snapshot.data![index].offPrecent.toString() +
                                      "%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      snapshot.data![index].imageUrl!,
                                    ),
                                  ),
                                  Text(snapshot.data![index].productName!),
                                  Text(snapshot.data![index].offPrice!
                                      .toString()),
                                  Text(
                                    snapshot.data![index].price!.toString(),
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
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
}
