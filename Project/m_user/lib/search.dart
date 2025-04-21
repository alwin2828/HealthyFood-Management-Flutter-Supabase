import 'package:flutter/material.dart';
import 'package:m_user/main.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchController = TextEditingController();
  late PageController _pageController;
  List<Map<String, dynamic>> foodData = [];
  List<Map<String, dynamic>> filteredFoodData = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchData();
    _searchController.addListener(() {
      filterSearchResults(_searchController.text);
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_food').select();
      print("Food Data: $response");
      setState(() {
        foodData = List<Map<String, dynamic>>.from(response);
        filteredFoodData = foodData; // Initially show all items
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> searchResults = [];
    if (query.isEmpty) {
      searchResults = foodData;
    } else {
      searchResults = foodData.where((food) {
        final name = food['food_name']?.toString().toLowerCase() ?? '';
        final description = food['food_description']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || description.contains(searchLower);
      }).toList();
    }
    
    setState(() {
      filteredFoodData = searchResults;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.green.shade200,
        //       Colors.white,
        //     ],
        //     begin: AlignmentDirectional.topCenter,
        //     end: AlignmentDirectional.bottomCenter,
        //   ),
        // ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Colors.black45),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Search food items',
                  label: Text("Search"),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredFoodData.isEmpty
                  ? Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(15),
                      itemCount: filteredFoodData.length.clamp(0, 5),
                      itemBuilder: (context, index) {
                        final food = filteredFoodData[index];
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food['food_name'] ?? 'Unnamed Item',
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_outward),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}