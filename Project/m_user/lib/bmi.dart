import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String selectedGender = "Male";
  double? bmi;
  String bmiCategory = '';

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;

    if (height > 0 && weight > 0 && age > 0) {
      double heightInMeters = height / 100;
      double calculatedBMI = weight / (heightInMeters * heightInMeters);
      setState(() {
        bmi = calculatedBMI;
        bmiCategory = getBMICategory(calculatedBMI);
      });
    }
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:  Icon(Icons.arrow_back_ios)),
        title: Text("BMI Calculator"),
        centerTitle: false,
        // backgroundColor: Color(0xFF25A18B),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Colors.green.shade200, Colors.white],
        //   ),
        // ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderButton(
                    title: "Male",
                    icon: Icons.male,
                    isSelected: selectedGender == "Male",
                    onTap: () => setState(() => selectedGender = "Male"),
                  ),
                  SizedBox(width: 20),
                  GenderButton(
                    title: "Female",
                    icon: Icons.female,
                    isSelected: selectedGender == "Female",
                    onTap: () => setState(() => selectedGender = "Female"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              InputField(controller: ageController, label: "Age"),
              SizedBox(height: 10),
              InputField(controller: heightController, label: "Height (cm)"),
              SizedBox(height: 10),
              InputField(controller: weightController, label: "Weight (kg)"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMI,
                child: Text("Calculate", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25A18B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                ),
              ),
              if (bmi != null) ...[
                SizedBox(height: 30),
                ResultCard(bmi: bmi!, category: bmiCategory),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? const Color(0xFF25A18B): Colors.grey.shade300,
            child: Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.black),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const InputField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final double bmi;
  final String category;

  const ResultCard({required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("BMI Score", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text(bmi.toStringAsFixed(1), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green.shade400)),
            SizedBox(height: 10),
            Text(category, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
