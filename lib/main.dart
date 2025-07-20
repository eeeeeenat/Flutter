import 'dart:io' show Platform, exit;
import 'package:android_intent_plus/android_intent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

    //loading screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 255, 230),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Apply rounded corners
            child: Image.asset(
              'assets/logo.png',
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
            Text(
              'Soil Macronutrient Analyzer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        backgroundColor: const Color.fromARGB(255, 229, 255, 230),
        body: Center(
          child: Container(
                  height: 500 ,
                  width: 300,
                  constraints: const BoxConstraints(minHeight: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 70),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 35),
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
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('Initialize App', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _showExitDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('Exit App', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
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
  //wifi config
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 255, 230),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 229, 255, 230),
        title: const Text(
          'Configuration Page',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text('Note: Please ensure that both Wi-Fi and GPS are enabled on your device in order to proceed and access the main features on application.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SwitchListTile(
                            title: const Text('Wi-Fi (Internet Connection)'),
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
                            secondary: const Icon(Icons.wifi),
                            activeColor: Colors.white,
                            activeTrackColor: Colors.green,
                          ),
                          SwitchListTile(
                            title: const Text('GPS (Location)'),
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
                            secondary: const Icon(Icons.gps_fixed),
                            activeColor: Colors.white,
                            activeTrackColor: Colors.green,
                          ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (isWifiOn && isGpsOn)
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnalyzerHomePage(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 3,
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
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
      ProfilePage(),
      Center(),
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
                                                                              // Back icon row
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ],
        ),
        
                                                                             // Add spacing and center the Dashboard title
        
        Center(
          child: Text(
            "HOME PAGE",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1,
            ),
          ),
        ),
        
        SizedBox(height: 20),

                                                                               // Nutrient container
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            children: [
              Text("RECENT FINDINGS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 5),
              buildNutrientRow("Nitrogen", nitrogen, Colors.green),
              buildNutrientRow("Potassium", potassium, Colors.green),
              buildNutrientRow("Phosphorus", phosphorus, Colors.green),
              buildNutrientRow("Acidity", acidity, Colors.green),
            ],
          ),
        ),

        // Field details container
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          height: 300, // Required for map to render
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(14.5995, 120.9842), // Example: Manila
                zoom: 12,
              ),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                // Optionally store the controller
              },
            ),
          ),
        ),
        SizedBox(height: 10),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green),
                        SizedBox(width: 10),
                        Text("Field 1", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.spa, size: 40, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(child: Text("Add compost to improve soil health.")),
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
          Expanded(flex: 2, child: Text(label, style: TextStyle(fontSize: 12))),
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
          BottomNavigationBarItem(icon: Icon(Icons.science), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
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
          nitrogen = "90%";
          phosphorus = "50%";
          potassium = "70%";
          ph = "40%";

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
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" FINDINGS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              status,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ],
  ),
);

  }

@override
Widget build(BuildContext context) {
  return Container(
    color: const Color(0xFFF4FFF4),
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // Back button aligned to the left
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),

        const SizedBox(height: 20),

        // Centered title
        const Center(
          child: Text(
            "SOIL ANALYZING",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
          SizedBox(height: 50),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            
          ),

          SizedBox(height: 10),

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
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(width: 8),
              SizedBox(height: 15),
              Align(alignment: Alignment.center,
            ),
          ],
        ),
        Center(
          child: Text(
            "HISTORY",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1,
            ),
          ),
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

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4FFF4),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(width: 10),
            ],
          ),
          Center(
            child: Text(
                "PROFILE",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ),
          SizedBox(height: 30),

          // Profile Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green.shade100,
                  child: Icon(Icons.person, size: 50, color: Colors.green),
                ),
                SizedBox(height: 12),
                Text("John Earl", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("noelitingancamacho@example.com", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Settings and Logout
          ListTile(
            leading: Icon(Icons.settings, color: Colors.green),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => SettingsPage())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SoilMacronutrientAnalyzerApp()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoCalibrate = true;
  bool darkMode = false;

  final TextEditingController nitrogenOffset = TextEditingController();
  final TextEditingController phosphorusOffset = TextEditingController();
  final TextEditingController potassiumOffset = TextEditingController();

  @override
  void dispose() {
    nitrogenOffset.dispose();
    phosphorusOffset.dispose();
    potassiumOffset.dispose();
    super.dispose();
  }

  void _exportData() {
    // Add CSV or PDF export logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exporting data...")),
    );
  }

  void _resetCalibration() {
    setState(() {
      nitrogenOffset.text = "";
      phosphorusOffset.text = "";
      potassiumOffset.text = "";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calibration values reset")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS"),
        backgroundColor: Color.fromARGB(255, 229, 255, 230),
        centerTitle: true,
      ),
     
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          

          // 🌿 Sensor Calibration
          Text("Component Calibration", style: sectionHeaderStyle),
          SizedBox(height: 10),
          calibrationField("Nitrogen Offset", nitrogenOffset),
          calibrationField("Phosphorus Offset", phosphorusOffset),
          calibrationField("Potassium Offset", potassiumOffset),
          SwitchListTile(
            title: Text("Auto Calibrate on Launch"),
            value: autoCalibrate,
            onChanged: (value) {
              setState(() {
                autoCalibrate = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _resetCalibration,
                icon: Icon(Icons.refresh),
                label: Text("Reset"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Save calibration values to storage or backend
                },
                icon: Icon(Icons.save),
                label: Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white),
              ),
            ],
          ),

          Divider(height: 40),

          // ⚙️ Preferences
          Text("App Preferences", style: sectionHeaderStyle),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
          ),

          Divider(height: 40),

          // 📤 Export Options
          Text("Data Management", style: sectionHeaderStyle),
          ElevatedButton.icon(
            onPressed: _exportData,
            icon: Icon(Icons.download),
            label: Text("Export Soil Reports"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              // Clear local history or show confirmation dialog
            },
            icon: Icon(Icons.delete),
            label: Text("Clear History"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white),
          ),

          Divider(height: 40),

          // ❓ About & Support
          Text("About", style: sectionHeaderStyle),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Version 1.0.0"),
            subtitle: Text("Soil Macronutrient Analyzer"),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Send Feedback"),
            onTap: () {
              // Add email intent or feedback form
            },
          ),
        ],
      ),
    );
  }

  // Reusable TextField for calibration input
  Widget calibrationField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixText: "±",
        ),
      ),
    );
  }

  TextStyle get sectionHeaderStyle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.green[800],
  );
}
