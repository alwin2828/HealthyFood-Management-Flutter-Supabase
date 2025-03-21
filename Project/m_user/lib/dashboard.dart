import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m_user/diet_plans.dart';
import 'package:m_user/bmi.dart';
import 'package:m_user/cart.dart';
import 'package:m_user/main.dart';
import 'package:m_user/my_profile.dart';
import 'package:m_user/orders.dart';
import 'package:m_user/search.dart';
import 'package:m_user/services/cart_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _pageController;
  int _currentPage = 0;
  final cartService = ItemService();

  void addItemToItem(BuildContext context, int itemId) {
    cartService.addToitem(context, itemId);
  }
  @override
  void initState() {
    super.initState();
    fetchData();
    _pageController = PageController(initialPage: _currentPage);

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  List<Map<String, dynamic>> food = [];

  List<Map<String, dynamic>> foodData = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_food').select();
      print("Food Data: $response");
      setState(() {
        foodData = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> images = [
    'assets/ads_1.jpg',
    'assets/ads_2.jpg',
    'assets/ads_3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.white,
            //     Colors.white,
            //   ],
            //   begin: AlignmentDirectional.topCenter,
            // ),
            ),
        child: SafeArea(
          child: Column(
            children: [
              // Fixed Header with Location and Search
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                // color: Colors.green.shade200,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.location_on_sharp),
                      title: Text("Piravom"),
                      subtitle: Text("Ernakulam"),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfile(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          child: Text("A"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black45),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: 'Search with respect your Diet Plan',
                            label: Text("Search"),
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchProduct(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable Content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: GridView(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 15,
                        ),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BMICalculatorApp(),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Flexible(
                                        child: 
                                        Image.asset('assets/bmi.png', )
                                        ),
                                    Text("BMI Calculator")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyOrders(),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Flexible(
                                        child: Image.asset('assets/cart.png')),
                                    Text("My Orders")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DietPlan(),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Flexible(
                                        child: Image.asset('assets/meal.png')),
                                    Text("Diet Plan")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Today's offers",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: images.length,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            images[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: images.length,
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: Color(0xFF25A18B),
                                        dotColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Recommended For You",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            SizedBox(height: 12),
                            ...foodData
                                .map((food) => _buildFoodCard(food))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return Container(
      margin: EdgeInsets.only(
          bottom:
              8), // Note: 'custom' isn't a valid parameter, assuming 'bottom'
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: food['food_photo'],
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 150,
                height: 150,
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 150,
                height: 150,
                color: Colors.grey[300],
                child: Icon(Icons.fastfood, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['food_name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  food['food_description'],
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 3, // Limit description length
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: food['food_type'] == 'Veg'
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    food['food_type'],
                    style: TextStyle(
                      fontSize: 12,
                      color: food['food_type'] == 'Veg'
                          ? Colors.green[800]
                          : Colors.red[800],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "₹${food['food_price']}",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: (){
            addItemToItem(context, food['id']);
          }, icon: Icon(Icons.add_circle, color: Color(0xFF25A18B))),
        ],
      ),
    );
  }
}
