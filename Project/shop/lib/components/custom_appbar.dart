import 'package:flutter/material.dart';
import 'package:shop/my_profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const CustomAppBar({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparent AppBar
      elevation: 0, // No shadow
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Row(
        children: [
          Icon(Icons.location_on_sharp, color: Colors.black),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nutirgo",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("Ernakulam",
                  style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('Home', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Complaint', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Stock', style: TextStyle(color: Colors.black)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyProfile()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
