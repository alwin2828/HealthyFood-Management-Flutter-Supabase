import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DietPlan extends StatefulWidget {
  const DietPlan({super.key});

  @override
  State<DietPlan> createState() => _DietPlanState();
}

class _DietPlanState extends State<DietPlan> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dietPlans = [];
  List<Map<String, dynamic>> dietTypes = [];
  String? selectedDietTypeId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDietTypes();
    fetchDietPlans();
  }

  Future<void> fetchDietTypes() async {
    try {
      final response = await supabase.from('tbl_diettype').select();
      setState(() {
        dietTypes = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching diet types: $e')),
      );
    }
  }

  Future<void> fetchDietPlans() async {
    setState(() => isLoading = true);
    try {
      final query = supabase.from('tbl_dietplan').select();
      
      // Apply filter if a diet type is selected
      final response = selectedDietTypeId != null
          ? await query.eq('diettype_id', selectedDietTypeId!)
          : await query;

      setState(() {
        dietPlans = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching diet plans: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet Plans"),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            // Diet Type Filter
            Padding(
              padding: EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                value: selectedDietTypeId,
                decoration: InputDecoration(
                  labelText: 'Filter by Diet Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('All Diet Types'),
                  ),
                  ...dietTypes.map((type) => DropdownMenuItem(
                        value: type['id'].toString(),
                        child: Text(type['diettype_name']),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDietTypeId = value;
                  });
                  fetchDietPlans();
                },
              ),
            ),
            // Diet Plans List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : dietPlans.isEmpty
                      ? Center(
                          child: Text(
                            "No diet plans found",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: dietPlans.length,
                          itemBuilder: (context, index) {
                            return _buildDietPlanCard(dietPlans[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietPlanCard(Map<String, dynamic> plan) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Diet Plan #${plan['id']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  plan['dietplan_type'],
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Calories: ${plan['dietplan_calories']}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          _buildMealRow("Breakfast", plan['dietplan_breakfast']),
          _buildMealRow("Lunch", plan['dietplan_lunch']),
          _buildMealRow("Dinner", plan['dietplan_dinner']),
        ],
      ),
    );
  }

  Widget _buildMealRow(String mealType, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}