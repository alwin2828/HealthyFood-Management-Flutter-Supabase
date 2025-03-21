
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
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
          children: [
            SizedBox(
              height: 20,
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
                    hintText: 'Shop name or Product name',
                    label: Text("Search"),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}