import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async'; // Needed for Timer

void main() {
  runApp(SoilMacronutrientAnalyzerApp());
}

// Root widget with SplashScreen as starting screen
class SoilMacronutrientAnalyzerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Macronutrient Analyzer',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
    );
  }
}

// Splash Screen (Opening Interface)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to main app after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeRoute()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 100, color: Colors.green[800]),
            SizedBox(height: 20),
            Text(
              'Soil Macronutrient Analyzer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Big App Icon (you can replace with Image.asset for custom logo)
              Icon(
                Icons.eco, // Use any icon or replace with your own image
                size: 170,          // Make it big
                color: Colors.green,
              ),

              SizedBox(height: 30), // Spacing between icon and button

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoutePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(150, 50),
                ),
                child: const Text(
                  'INITIALIZE',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool isWifiOn = false;
  bool isGpsOn = false;

  void _checkAndProceed() {
    if (isWifiOn && isGpsOn) {
      // Action when both switches are on
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proceeding with testing...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Wi-Fi'),
              value: isWifiOn,
              onChanged: (value) {
                setState(() {
                  isWifiOn = value;
                });
              },
              secondary: Icon(Icons.wifi),
              activeColor: Colors.green, // thumb color when ON
              activeTrackColor: Colors.greenAccent, // track color when ON
            ),
            SwitchListTile(
              title: Text('GPS'),
              value: isGpsOn,
              onChanged: (value) {
                setState(() {
                  isGpsOn = value;
                });
              },
              secondary: Icon(Icons.gps_fixed),
              activeColor: Colors.green, // thumb color when ON
              activeTrackColor: Colors.greenAccent, // track color when ON
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (isWifiOn && isGpsOn)? () {
                Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => AnalyzerHomePage()),
                );
            }
            : null,
              child: Text('Proceed Testing'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Analyzer Page (With Exit Confirmation + NPK readings)
class AnalyzerHomePage extends StatefulWidget {
  @override
  _AnalyzerHomePageState createState() => _AnalyzerHomePageState();
}

class _AnalyzerHomePageState extends State<AnalyzerHomePage> {
  bool isPoweredOn = false;

  // Simulated nutrient values (0 to 100)
  double nitrogen = 0;
  double phosphorus = 0;
  double potassium = 0;
  double pH = 0;
  double ec = 0;

  void togglePower() {
    setState(() {
      isPoweredOn = !isPoweredOn;
      if (isPoweredOn) {
        nitrogen = 0;
        phosphorus = 0;
        potassium = 0;
        pH = 0;
        ec = 0;
      } else {
        nitrogen = 0;
        phosphorus = 0;
        potassium = 0;
        pH = 0;
        ec = 0;
      }
    });
  }

  Widget buildNutrientBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: value / 100,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitDialog,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Soil Macronutrient Analyzer'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                isPoweredOn ? Icons.power : Icons.power_off,
                size: 100,
                color: isPoweredOn ? Colors.green : Colors.red,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: togglePower,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPoweredOn ? Colors.red : Colors.green,
                  minimumSize: Size(150, 50),
                ),
                child: Text(isPoweredOn ? 'Power OFF' : 'Power ON',
                    style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 40),
              buildNutrientBar('Nitrogen (N)', nitrogen, Colors.blue),
              buildNutrientBar('Phosphorus (P)', phosphorus, Colors.orange),
              buildNutrientBar('Potassium (K)', potassium, Colors.purple),
              buildNutrientBar('Acidity (pH)', potassium, Colors.yellow),
              buildNutrientBar('Electric Conductive (ec)', potassium, Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
