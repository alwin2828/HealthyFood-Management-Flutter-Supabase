import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected ;
  const SideButton({super.key, required this.name, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? Color.fromARGB(255, 24, 157, 72) : null,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Container(
          width: 180,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: selected ? Color(0xFFD9F3EA) : null,
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    selected ? Color.fromARGB(255, 24, 157, 72) : Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: TextStyle(
                    color: selected
                        ? Color.fromARGB(255, 24, 157, 72)
                        : Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
