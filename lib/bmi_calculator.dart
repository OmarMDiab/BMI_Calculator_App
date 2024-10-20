import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedGender;
  double bmiResult = 0.0;
  String healthStatus = "";
  bool isLoggedIn = false;
  bool showResult = false;

  // Method to get the appropriate avatar image based on gender
  Widget getAvatar() {
    String imageUrl;

    switch (selectedGender) {
      case 'Male':
        imageUrl = 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png';
        break;
      case 'Female':
        imageUrl = 'https://cdn-icons-png.flaticon.com/512/2922/2922565.png';
        break;
      default:
        imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXU4XgzNrGtngfVHsAfBaLPvrXATF-qtoupA&s'; // Default avatar
    }

    return SizedBox(
      width: 100,
      height: 100,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
              size: 100,
              color: Colors.red,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void calculateBMI() {
    double height = double.parse(heightController.text) / 100;
    double weight = double.parse(weightController.text);

    setState(() {
      bmiResult = weight / (height * height);
      healthStatus = getHealthStatus(bmiResult);
      showResult = true; // Show result only after calculation
    });
  }

  String getHealthStatus(double bmi) {
    if (bmi < 0) {
      return "Invalid";
    } else if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi <= 24) {
      return "Normal";
    } else if (bmi > 24) {
      return "Overweight";
    } else {
      return "Invalid";
    }
  }

  void resetFields() {
    heightController.clear();
    weightController.clear();
    setState(() {
      selectedGender = null;
      bmiResult = 0.0;
      healthStatus = "";
      showResult = false; // Hide result after reset
    });
  }

  void toggleLogin() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('BMI Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menu clicked!")),
              );
            },
          ),
          TextButton(
            onPressed: toggleLogin,
            child: Text(isLoggedIn ? 'Logout' : 'Login',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Your Height (cm)',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Your Weight (KG)',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedGender,
              hint: const Text('Select Gender'),
              items: ['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            getAvatar(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                  onPressed: calculateBMI,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  onPressed: resetFields,
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (showResult) // Conditionally show result box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      selectedGender != null
                          ? 'The $selectedGender Result'
                          : 'The Result',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'BMI Calculated = ${bmiResult.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current Status = $healthStatus',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      bmiResult < 18.5
                          ? Icons.sentiment_dissatisfied
                          : bmiResult <= 24
                          ? Icons.sentiment_satisfied
                          : Icons.sentiment_very_dissatisfied,
                      color: Colors.white,
                      size: 50,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
