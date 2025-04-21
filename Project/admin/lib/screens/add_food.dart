import 'package:admin/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  TextEditingController nameController = TextEditingController();
  final TextEditingController _photo = TextEditingController();
  TextEditingController discrptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  PlatformFile? pickedImage;

 Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
        _photo.text = pickedImage!.name;
      });
    }
  }

  Future<String?> uploadFile(PlatformFile? file) async {
    if (file == null) return null;
    try {
      final filePath = "food-${DateTime.now().millisecondsSinceEpoch}-${file.name}";
      await supabase.storage.from('shop').uploadBinary(filePath, file.bytes!);
      return supabase.storage.from('shop').getPublicUrl(filePath);
    } catch (e) {
      print("Error uploading: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> insert() async {
    try {
      String? photoUrl = await uploadFile(pickedImage);
      await supabase.from("tbl_food").insert({
        "food_type": selectedtype,
        "food_name": nameController.text,
        "food_photo": photoUrl ?? '',
        "food_description": discrptionController.text,
        "food_price": priceController.text,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

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
            "Food",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
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
                SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Product Name',
                    labelText: "Enter Product Name",
                    prefixIcon:
                        Icon(Icons.food_bank_outlined, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  onTap: handleImagePick,
                  controller: _photo,
                  decoration: InputDecoration(
                    hintText: 'Upload Image',
                    labelText: "Product Image",
                    prefixIcon: Icon(Icons.image_outlined, color: Colors.teal),
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
                  minLines: 3,
                  maxLines: null,
                  controller: discrptionController,
                  decoration: InputDecoration(
                    hintText: 'Discrption',
                    labelText: "Enter Discrption",
                    prefixIcon: Icon(Icons.details, color: Colors.teal),
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: 'Enter Price',
                    labelText: "Price",
                    prefixIcon:
                        Icon(Icons.price_change_outlined, color: Colors.teal),
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
        ],
      ),
    );
  }
}
