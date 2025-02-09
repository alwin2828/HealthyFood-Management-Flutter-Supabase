import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor:Colors.blue[200] ,
      title: Text('Shop',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      actions: [
        ElevatedButton(onPressed: (){}, child: Text("Login",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(onPressed: (){}, child: Text("Sign in",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
         SizedBox(
          width: 10,
        ),        
      ],  
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 700, child: Text('A smart solution for fresh, personalized meal prep and fitness goals.',textAlign: TextAlign.center,style: GoogleFonts.bungeeHairline(fontSize: 35,fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        )),
      
    );
  }
}