import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Diettype extends StatefulWidget {
  const Diettype({super.key});

  @override
  State<Diettype> createState() => _DiettypeState();
}

class _DiettypeState extends State<Diettype> {
  TextEditingController diettype=TextEditingController();
  List<Map<String,dynamic>>fechdiettype=[];

@override
void initState(){
  super.initState();
  fetchdata();
}
  
  Future<void> insert()async
  {
    try {
      await supabase.from("tbl_diettype").insert({"diettype_name":diettype.text});
      fetchdata();
      print("inserted");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("inserted")));

    } catch (e) {
      print("error $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error $e")));
      
    }
  }
  Future<void>fetchdata()async{
    try {
      final response=await supabase.from("tbl_diettype").select();
      setState(() {
        fechdiettype=response;
      });
    } catch (e) {
      
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_diettype').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  int editId = 0;

  Future<void> update() async {
    try {
      await supabase.from("tbl_diettype").update({
        "diettype_name":diettype.text
      }).eq('id', editId);
      fetchdata();
      diettype.clear();
      setState(() {
        editId=0;
      });
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Form(
        child: Center(
        child: Padding(padding:
        const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Diet Type",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color.fromARGB(255, 24, 157, 72),
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: diettype,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:BorderSide(width: 2,color:Color.fromARGB(255, 24, 157, 72),),
                        ),
                        hintText: 'Enter diet type',
                        label: Text("Diet Type"),
                        prefixIcon: Icon(Icons.location_city_rounded),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    if(editId==0){
                      insert();
                    }
                    else{
                      update();
                    }
                  },child: Text("Submit",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF25A18B)
                  ),)
                ],
              ),
            ),
            Expanded(child: 
            ListView.builder(itemCount:fechdiettype.length, 
            itemBuilder: (context, index) {
              final _diettype=fechdiettype[
                index
              ];
              return ListTile(
                leading: Text(
                _diettype['diettype_name'],
                ),
                trailing: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        delete(_diettype['id']);
                      }, icon: Icon(Icons.delete_outline)),
                      IconButton(onPressed: (){
                        setState(() {
                          diettype.text=_diettype['diettype_name'];
                          editId=_diettype['id'];
                        });
                      }, icon: Icon(Icons.edit))
                    ],
                  ),
                ),
              );
            },),),
          ],
        ),
        ),
      )),
    );
  }
}