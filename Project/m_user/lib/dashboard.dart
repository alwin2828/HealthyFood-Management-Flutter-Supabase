import 'package:flutter/material.dart';
import 'package:m_user/DietPlan.dart';
import 'package:m_user/cart.dart';
import 'package:m_user/login.dart';
import 'package:m_user/my_profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.green.shade200,
          Colors.white,
        ], begin: AlignmentDirectional.topCenter)),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        ));
                },
                child: CircleAvatar(
                  child: Text("A"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                // controller: _search,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(width: 2, color: Colors.black45),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Search with respect your Diet Plan',
                    label: Text("Search"),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            GridView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              shrinkWrap: true,
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
                          builder: (context) => DietPlan(),
                        ));
                  },
                  child: Card(
                    color: Colors.green.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Flexible(child: Image.asset('assets/bmi.png')),
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
                          builder: (context) => cart(),
                        ));
                  },
                  child: Card(
                    color: Colors.green.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Flexible(child: Image.asset('assets/cart.png')),
                          Text("My Cart")
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
                        ));
                  },
                  child: Card(
                    color: Colors.green.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Flexible(child: Image.asset('assets/meal.png')),
                          Text("Diet Plan")
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
