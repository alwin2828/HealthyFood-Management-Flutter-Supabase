import 'package:flutter/material.dart';
import 'package:worker/cart.dart';
import 'package:worker/main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DineIn extends StatefulWidget {
  const DineIn({super.key});

  @override
  State<DineIn> createState() => _DineInState();
}

class _DineInState extends State<DineIn> {
  List<Map<String, dynamic>> foodData = [];
  bool isLoading = true;
  List<int> selectedFoodIds = []; // Store selected food IDs
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_food').select();
      setState(() {
        foodData = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoodData = foodData.where((food) {
      final name = (food['food_name'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dine In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_checkout, size: 38,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(food: selectedFoodIds),));
                },
              ),
              if (selectedFoodIds.isNotEmpty)
                Positioned(
                  right: 4, // Adjust as needed
                  top: 4,   // Adjust as needed
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    child: Text(
                      '${selectedFoodIds.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search food...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredFoodData.isEmpty
                        ? Center(
                            child: Text(
                              'No food items available',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredFoodData.length,
                            itemBuilder: (context, index) {
                              final food = filteredFoodData[index];
                              return _buildFoodCard(context, food);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, Map<String, dynamic> food) {
    final foodId = food['id'] as int;
    final isSelected = selectedFoodIds.contains(foodId);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
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
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: Icon(Icons.fastfood, size: 40, color: Colors.grey[600]),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3547),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  food['food_description'] ?? 'No description',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  selectedFoodIds.remove(foodId);
                } else {
                  selectedFoodIds.add(foodId);
                }
              });
            },
            icon: Icon(
              isSelected ? Icons.remove_circle : Icons.add_circle,
              color: isSelected ? Colors.red : Colors.green, // Green for add, red for remove
            ),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}