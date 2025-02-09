import 'package:admin/components/sidebutton.dart';
import 'package:admin/screens/diettype.dart';
import 'package:admin/screens/district.dart';
import 'package:admin/screens/profile.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  List<String> pageName = [
    'Profile',
    'District',
    'Diet Type',
  ];

  List<IconData> pageIcon = [
    Icons.account_circle,
    Icons.location_on,
    Icons.food_bank_outlined,
  ];

  List<Widget> pageContent = [
    Profile(),
    Distrect(),
    Diettype(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2F7),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: pageName.length,
                itemBuilder: (context, index) {
                  bool selected = false;
                  if(selectedIndex == index){
                    selected = true;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        print(index);
                        selectedIndex = index;
                      });
                    },
                    child: SideButton(name: pageName[index], icon: pageIcon[index], selected: selected, )
                  );
                  // ListTile(
                  //   onTap: () {
                  //     setState(() {
                  //       print(index);
                  //       selectedIndex = index;
                  //     });
                  //   },
                  //   leading: Icon(pageIcon[index]),
                  //   title: Text(pageName[index]),
                  // );
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: pageContent[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
