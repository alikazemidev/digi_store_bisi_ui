import './apiUrl.dart';
import './models/event_model.dart';
import './models/page_view_model.dart';
import './models/special_offer_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'vazir'),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<PageViewModel>>? futurePageView;
  Future<List<SpecialOfferModel>>? futureSpecial;
  Future<List<EventsModel>>? futureEvents;
  PageController pageController = PageController();

// *slider
  Future<List<PageViewModel>> sendRequestPageView() async {
    List<PageViewModel> model = [];
    try {
      var response = await Dio().get(apiUrl);
      print(response.statusCode);
      for (var item in response.data['products']) {
        model.add(
          PageViewModel(
            item['id'],
            item['imageUrl'],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    return model;
  }

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

// *events poster
  Future<List<EventsModel>> sendRequestEvents() async {
    List<EventsModel> models = [];
    var response = await Dio().get(offerProductAPI);
    for (var item in response.data["products"]) {
      models.add(
        EventsModel(
          imageurl: item["imageUrl"],
        ),
      );
    }

    return models;
  }

  @override
  void initState() {
    super.initState();
    futurePageView = sendRequestPageView();
    futureSpecial = sendRequestSpecialOffer();
    futureEvents = sendRequestEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('DigiStore'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  *slider
            Container(
              height: 250,
              child: FutureBuilder<List<PageViewModel>>(
                future: futurePageView,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var model = snapshot.data;
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: pageController,
                          allowImplicitScrolling: true,
                          itemCount: model!.length,
                          itemBuilder: (context, index) {
                            return PageViewItems(model[index]);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: model.length,
                            effect: WormEffect(
                              activeDotColor: Colors.red,
                              dotColor: Colors.white,
                              dotHeight: 10,
                              dotWidth: 10,
                            ),
                            onDotClicked: (index) {
                              pageController.animateToPage(
                                index,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.bounceOut,
                              );
                            },
                          ),
                        ),
                      ],
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
            // *specail offer
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                color: Colors.red,
                height: 300,
                child: FutureBuilder<List<SpecialOfferModel>>(
                  future: futureSpecial,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // *first child of listview
                            return Container(
                              height: 300,
                              width: 200,
                              child: Column(
                                children: [
                                  //  *image on top of see all button
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Image.asset(
                                      'images/pic0.png',
                                      fit: BoxFit.cover,
                                      height: 230,
                                    ),
                                  ),
                                  // *see all button
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      )),
                                      onPressed: () {},
                                      child: Text(
                                        'مشاهده همه',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return specialOfferItem(snapshot.data![index - 1]);
                          }
                        },
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
            ),
            // *event poster
            Container(
              width: double.infinity,
              child: FutureBuilder<List<EventsModel>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<EventsModel> model = snapshot.data!;
                    return Container(
                      height: 400,
                      child: GridView.builder(
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            child: Image.network(
                              model[index].imageurl!,
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: JumpingDotsProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

// *slider page
  Widget PageViewItems(PageViewModel data) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 5,
        right: 5,
      ),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            data.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

// *special offer generator
  Widget specialOfferItem(SpecialOfferModel specialOfferModel) {
    return Container(
      width: 200,
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  specialOfferModel.imageUrl!,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(specialOfferModel.productName!),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              specialOfferModel.offPrice.toString() + 'T',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              specialOfferModel.price.toString() + 'T',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(bottom: 5, right: 5),
                        // alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: Text(
                            specialOfferModel.offPrecent.toString() + "%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
