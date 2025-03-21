import 'package:admin/main.dart';
import 'package:flutter/material.dart';

class DitePlan extends StatefulWidget {
  const DitePlan({super.key});

  @override
  State<DitePlan> createState() => _DitePlanState();
}

class _DitePlanState extends State<DitePlan> {
  List<Map<String, dynamic>> fechdiettype = [];
  List<Map<String, dynamic>> fechdietplan = [];
  TextEditingController caloriesController = TextEditingController();
  TextEditingController breakfastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchdata();
    fetchdatap();
  }

  Future<void> insert() async {
    try {
      await supabase.from("tbl_dietplan").insert({
        "diettype_id": selectedDiettype,
        "dietplan_type": selectedtype,
        "dietplan_calories": caloriesController.text,
        "dietplan_breakfast": breakfastController.text,
        "dietplan_lunch": lunchController.text,
        "dietplan_dinner": dinnerController.text
      });
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_diettype").select();
      setState(() {
        fechdiettype = response;
      });
    } catch (e) {
      print("Error Diet Type $e");
    }
  }

  Future<void> fetchdatap() async {
    try {
      final response = await supabase.from("tbl_dietplan").select('*,tbl_diettype(*)');
      setState(() {
        fechdietplan = response;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_dietplan').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  String? selectedDiettype;
  String? selectedtype;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Diet Plan",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: 'Select Diet Type',
                    prefixIcon: Icon(Icons.restaurant, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                  value: selectedDiettype,
                  items: fechdiettype.map((diettype) {
                    return DropdownMenuItem(
                      value: diettype['id'].toString(),
                      child: Text(diettype['diettype_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDiettype = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(
                    hintText: 'Enter Calories',
                    labelText: "Calories",
                    prefixIcon: Icon(Icons.local_fire_department, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Food Type: "),
                    Radio(
                      value: "Veg",
                      groupValue: selectedtype,
                      onChanged: (e) {
                        setState(() {
                          selectedtype = e!;
                        });
                      },
                    ),
                    Text("Veg"),
                    Radio(
                      value: "Non Veg",
                      groupValue: selectedtype,
                      onChanged: (e) {
                        setState(() {
                          selectedtype = e!;
                        });
                      },
                    ),
                    Text("Non Veg"),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: breakfastController,
                  decoration: InputDecoration(
                    hintText: 'Enter Breakfast',
                    labelText: "Breakfast",
                    prefixIcon: Icon(Icons.breakfast_dining, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: lunchController,
                  decoration: InputDecoration(
                    hintText: 'Enter Lunch',
                    labelText: "Lunch",
                    prefixIcon: Icon(Icons.lunch_dining, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dinnerController,
                  decoration: InputDecoration(
                    hintText: 'Enter Dinner',
                    labelText: "Dinner",
                    prefixIcon: Icon(Icons.dinner_dining, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: insert,
                    child: Text("Submit", style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: fechdietplan.isEmpty
                ? Center(child: Text("No data found"))
                : ListView.builder(
                    itemCount: fechdietplan.length,
                    itemBuilder: (context, index) {
                      final diets = fechdietplan[index];
                      return ListTile(
                        title: Text(diets['tbl_diettype']['diettype_name']),
                        subtitle: Text("Breakfast: ${diets['dietplan_breakfast']}\nLunch: ${diets['dietplan_lunch']}\nDinner: ${diets['dietplan_dinner']}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
