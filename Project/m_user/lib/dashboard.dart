import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m_user/custom_dropdown.dart';
import 'package:m_user/details.dart';
import 'package:m_user/diet_plans.dart';
import 'package:m_user/bmi.dart';
import 'package:m_user/cart.dart';
import 'package:m_user/main.dart';
import 'package:m_user/my_profile.dart';
import 'package:m_user/orders.dart';
import 'package:m_user/search.dart';
import 'package:m_user/services/cart_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _pageController;
  int _currentPage = 0;
  final cartService = ItemService();

  List<Map<String, dynamic>> foodData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    getDistrict();
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

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_food').select();
      setState(() {
        foodData = List<Map<String, dynamic>>.from(response);
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

  void showLoc() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Location"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDropdown(
                      label: "District",
                      items: district,
                      onChanged: (value) async {
                        dialogSetState(() {
                          selectedDistrict = value!;
                          place = []; // Reset place list
                          shop = []; // Reset shop list
                        });
                        await getPlace(value!);
                        dialogSetState(() {});
                      },
                      displayKey: "district_name",
                      valueKey: "id",
                      icon: Icons.location_city,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      label: "Place",
                      items: place,
                      onChanged: (value) async {
                        dialogSetState(() {
                          selectedPlace = value!;
                          shop = []; // Reset shop list
                        });
                        await getShop(value!);
                        dialogSetState(() {});
                      },
                      displayKey: "place_name",
                      valueKey: "id",
                      icon: Icons.place,
                    ),
                    const SizedBox(height: 16),
                    if (shop.isNotEmpty) ...[
                      Text(
                        "Select Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: shop.map((shopItem) {
                          return ChoiceChip(
                            label: Text(shopItem['shop_name']),
                            selected: selectedShop == shopItem['id'],
                            onSelected: (bool selected) {
                              dialogSetState(() {
                                selectedShop = selected ? shopItem['id'] : null;
                              });
                            },
                            selectedColor: Colors.blue[100],
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: selectedShop == shopItem['id']
                                  ? Colors.blue[800]
                                  : Colors.grey[800],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                if (shop.isNotEmpty)
                  TextButton(
                    onPressed: selectedShop != null
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('shop', selectedShop!);
                            print(selectedShop);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text("Confirm"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

// Add this to your state class variables
  String? selectedShop;

  List<Map<String, dynamic>> district = [];
  List<Map<String, dynamic>> place = [];
  List<Map<String, dynamic>> shop = [];
  String selectedDistrict = '';
  String selectedPlace = '';

  Future<void> getDistrict() async {
    final response = await supabase.from('tbl_district').select();

    setState(() {
      district = response;
    });
  }

  Future<void> getPlace(String id) async {
    final response =
        await supabase.from('tbl_place').select().eq('district_id', id);
    setState(() {
      place = response;
    });
  }

  Future<void> getShop(String id) async {
    try {
      final response =
          await supabase.from('tbl_shop').select().eq('place_id', id);
      setState(() {
        shop = response;
      });
      print(response[0]);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                      leading: GestureDetector(
                          onTap: () {
                            showLoc();
                          },
                          child: Icon(Icons.location_on_sharp)),
                      title: Text("Piravom"),
                      subtitle: Text("Ernakulam"),
                      trailing: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()),
                        ),
                        child: CircleAvatar(child: Text("A")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchProduct()),
                        ),
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
                          _buildGridItem(context, 'assets/bmi.png',
                              "BMI Calculator", BMICalculator()),
                          _buildGridItem(context, 'assets/cart.png',
                              "My Orders", MyOrders()),
                          _buildGridItem(context, 'assets/meal.png',
                              "Diet Plan", DietPlan()),
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
                                    onPageChanged: (index) =>
                                        setState(() => _currentPage = index),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(images[index],
                                              fit: BoxFit.cover),
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
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12),
                            ...foodData
                                .map((food) => _buildFoodCard(context, food))
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Cart())),
        child: Icon(Icons.shopping_cart, color: Colors.white),
        backgroundColor: Color(0xFF25A18B),
        shape: CircleBorder(), // Explicitly sets the shape to a circle
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String image, String title, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(child: Image.asset(image)),
              Text(title, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, Map<String, dynamic> food) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailsPage(food: food)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
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
                imageUrl: food['food_photo'] ?? '',
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
                  child:
                      Icon(Icons.fastfood, size: 50, color: Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['food_name'] ?? 'Unnamed',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    food['food_description'] ?? 'No description',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 3,
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
                      food['food_type'] ?? 'Unknown',
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
                    "₹${food['food_price']?.toString() ?? '0'}",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => ItemService().addToitem(context, food['id']),
              icon: Icon(Icons.add_circle, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
