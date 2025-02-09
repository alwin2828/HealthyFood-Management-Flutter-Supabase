import 'package:admin/main.dart';
import 'package:flutter/material.dart';

class Distrect extends StatefulWidget {
  const Distrect({super.key});

  @override
  State<Distrect> createState() => _DistrectState();
}

class _DistrectState extends State<Distrect> {
  TextEditingController district=TextEditingController();
  List<Map<String,dynamic>>fechdistrict=[];


@override
void initState(){
  super.initState();
  fetchdata();
}
  
  Future<void> insert()async
  {
    try {
      await supabase.from("tbl_district").insert({"district_name":district.text});
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
      final response=await supabase.from("tbl_district").select();
      setState(() {
        fechdistrict=response;
      });
    } catch (e) {
      
    }
  } 

  
  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_district').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  int editId = 0;

  Future<void> update() async {
    try {
      await supabase.from("tbl_district").update({
        "district_name":district.text
      }).eq('id', editId);
      fetchdata();
      district.clear();
      setState(() {
        editId=0;
      });
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
        child: Center(
        child: Padding(padding:
        const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("District",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                      controller: district,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:BorderSide(width: 2,color:Color.fromARGB(255, 24, 157, 72)),
                        ),
                        hintText: 'Enter Your District',
                        label: Text("District"),
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
                    backgroundColor: Color(0xFF25A18B)
                  ),)
                ],
              ),
            ),
            Expanded(child: 
            ListView.builder(itemCount:fechdistrict.length, 
            itemBuilder: (context, index) {
              final _district=fechdistrict[
                index
              ];
              return ListTile(
                leading: Text(
                _district['district_name'],
                ),
                trailing: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        delete(_district['id']);
                      }, icon: Icon(Icons.delete_outline)),
                      IconButton(onPressed: (){
                        setState(() {
                          district.text=_district['district_name'];
                          editId=_district['id'];
                        });
                      }, icon: Icon(Icons.edit))
                    ],
                  ),

              ));
            },),),
          ],
        ),
        ),
      ));
  }
}