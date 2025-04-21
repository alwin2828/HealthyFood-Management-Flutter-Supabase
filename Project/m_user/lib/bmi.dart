import 'package:flutter/material.dart';
import 'package:m_user/dashboard.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

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
  double? dailyCalories;
  String activityLevel = 'Sedentary';

  final List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active'
  ];

  void calculateBMIandCalories() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;

    if (height > 0 && weight > 0 && age > 0) {
      // Calculate BMI
      double heightInMeters = height / 100;
      double calculatedBMI = weight / (heightInMeters * heightInMeters);

      // Calculate BMR using Mifflin-St Jeor Equation
      double bmr;
      if (selectedGender == "Male") {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }

      // Apply activity multiplier
      double activityMultiplier;
      switch (activityLevel) {
        case 'Sedentary':
          activityMultiplier = 1.2;
          break;
        case 'Lightly Active':
          activityMultiplier = 1.375;
          break;
        case 'Moderately Active':
          activityMultiplier = 1.55;
          break;
        case 'Very Active':
          activityMultiplier = 1.725;
          break;
        case 'Extra Active':
          activityMultiplier = 1.9;
          break;
        default:
          activityMultiplier = 1.2;
      }

      setState(() {
        bmi = calculatedBMI;
        bmiCategory = getBMICategory(calculatedBMI);
        dailyCalories = bmr * activityMultiplier;
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
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("BMI & Calorie Calculator"),
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
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
              DropdownButtonFormField<String>(
                value: activityLevel,
                decoration: InputDecoration(
                  labelText: "Activity Level",
                  border: UnderlineInputBorder(),
                ),
                items: activityLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    activityLevel = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMIandCalories,
                child: Text("Calculate", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25A18B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                ),
              ),
              if (bmi != null && dailyCalories != null) ...[
                SizedBox(height: 30),
                ResultCard(
                  bmi: bmi!,
                  category: bmiCategory,
                  calories: dailyCalories!,
                ),
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

  const GenderButton(
      {required this.title,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                isSelected ? const Color(0xFF25A18B) : Colors.grey.shade300,
            child: Icon(icon,
                size: 40, color: isSelected ? Colors.white : Colors.black),
          ),
          SizedBox(height: 5),
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
  final double calories;

  const ResultCard({
    required this.bmi,
    required this.category,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("BMI Score",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 10),
            Text(bmi.toStringAsFixed(1),
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400)),
            SizedBox(height: 10),
            Text(category,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text("Daily Calorie Needs",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 10),
            Text("${calories.toStringAsFixed(0)} kcal",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400)),
          ],
        ),
      ),
    );
  }
}
