import 'package:digi_store_ui/apiUrl.dart';
import 'package:digi_store_ui/models/page_view_model.dart';
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
  PageController pageController = PageController();

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

  @override
  void initState() {
    super.initState();
    futurePageView = sendRequestPageView();
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
      body: Container(
        child: Column(
          children: [
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
                        )
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
          ],
        ),
      ),
    );
  }

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
}
