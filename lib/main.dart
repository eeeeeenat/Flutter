import 'dart:io' show Platform, exit;
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(SoilMacronutrientAnalyzerApp());
}

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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, size: 170, color: Colors.green),
              SizedBox(height: 30),
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
                child: const Text('Initialize App', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showExitDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(150, 50),
                ),
                child: const Text('Exit App', style: TextStyle(fontSize: 20)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Configuration Page'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Wi-Fi(Internet Connection)'),
              value: isWifiOn,
              onChanged: (value) {
                setState(() {
                  isWifiOn = value;
                });

                if (value && Platform.isAndroid) {
                final intent = AndroidIntent(
                action: 'android.settings.WIFI_SETTINGS',
                );
                intent.launch();
                }
              },
              secondary: Icon(Icons.wifi),
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
              
            ),
            SwitchListTile(
              title: Text('GPS(Location)'),
              value: isGpsOn,
              onChanged: (value) {
                setState(() {
                  isGpsOn = value;
                });
                if (value && Platform.isAndroid) {
                final intent = AndroidIntent(
                  action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                );
                intent.launch();
              }
              },
              secondary: Icon(Icons.gps_fixed),
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (isWifiOn && isGpsOn)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnalyzerHomePage()),
                      );
                    }
                  : null,
              child: Text('Proceed'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyzerHomePage extends StatefulWidget {
  @override
  _AnalyzerHomePageState createState() => _AnalyzerHomePageState();
}

class _AnalyzerHomePageState extends State<AnalyzerHomePage> {
  int _selectedIndex = 0;

  double nitrogen = 90;
  double potassium = 50;
  double phosphorus = 70;
  double acidity = 40;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      buildDashboardPage(),
      ScanningPage(),
      ReportPage(),
      Center(child: Text("Profile Page")),
    ];
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildDashboardPage() {
    return Container(
      color: Color(0xFFF4FFF4),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
            onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.green),
            ),
             Align(alignment: Alignment.center,
              child: Text("Dashboard", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
             )
            ]
          ),
          SizedBox(height: 100),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                
                buildNutrientRow("Nitrogen", nitrogen, Colors.green),
                buildNutrientRow("Potassium", potassium, Colors.green),
                buildNutrientRow("Phosphorus", phosphorus, Colors.green),
                buildNutrientRow("Acidity", acidity, Colors.green),
              ],
            ),
          ),
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Field 1", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.spa, size: 40, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(child: Text("Add compost to improve soil health")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNutrientRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: TextStyle(fontSize: 16))),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          SizedBox(width: 10),
          Text("${value.toInt()}%"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.radar), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}

class ScanningPage extends StatefulWidget {
  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  bool hasAnalyzed = false;
  bool isAnalyzing = false;
  int countdown = 5;
  Timer? _timer;

  String nitrogen = "";
  String phosphorus = "";
  String potassium = "";
  String ph = "";

  void startAnalysis() {
    setState(() {
      isAnalyzing = true;
      countdown = 5;
      hasAnalyzed = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown == 0) {
          timer.cancel();
          isAnalyzing = false;
          hasAnalyzed = true;

          // Fake results
          nitrogen = "Normal";
          phosphorus = "High";
          potassium = "Low";
          ph = "Low";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Soil analysis complete!')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget nutrientResult(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          Text(status, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4FFF4),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.green),
              ),
              SizedBox(width: 10),
              Center(child: Text("Start Soil Analysis", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
            ],
          ),
          SizedBox(height: 70),

          // Analysis button with timer
          GestureDetector(
            onTap: isAnalyzing ? null : startAnalysis,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isAnalyzing ? Colors.grey : Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    isAnalyzing
                        ? "Analyzing... ($countdown)"
                        : "Start Soil Analysis",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40),

          if (hasAnalyzed)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  nutrientResult("Nitrogen", nitrogen),
                  nutrientResult("Phosphorus", phosphorus),
                  nutrientResult("Potassium", potassium),
                  nutrientResult("pH", ph),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


class ReportPage extends StatelessWidget {
  Widget nutrientBar(String label, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
            ),
          ),
          SizedBox(width: 8),
          Text("${percent.toInt()}%"),
        ],
      ),
    );
  }

  Widget reportCard({
    required String date,
    bool showView = false,
    required List<Map<String, dynamic>> nutrients,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                showView ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (showView) Text("View >", style: TextStyle(color: Colors.black54)),
            ],
          ),
          SizedBox(height: 12),
          ...nutrients.map((n) => nutrientBar(n['label'], n['value'])).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4FFF4),
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.green),
              ),
              SizedBox(width: 8),
              Align( alignment: Alignment.center,
              child: Text(
                "History",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        reportCard(
            date: "April 26, 2025",
            nutrients: [
              {'label': 'Nitrogen', 'value': 90.0},
              {'label': 'Potassium', 'value': 50.0},
              {'label': 'Phosphorus', 'value': 70.0},
              {'label': 'Acidity', 'value': 40.0},
            ],
          ),
          reportCard(
            date: "March 24, 2025",
            showView: true,
            nutrients: [
              {'label': 'Nitrogen', 'value': 50.0},
              {'label': 'Potassium', 'value': 70.0},
            ],
          ),
           reportCard(
            date: "Feb 22, 2025",
            showView: true,
            nutrients: [
              {'label': 'Nitrogen', 'value': 40.0},
              {'label': 'Potassium', 'value': 80.0},
            ],
          ),
          ]
        )
      ),
    );
  }
}
