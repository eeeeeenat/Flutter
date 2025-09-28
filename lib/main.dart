import 'dart:io' show Platform, exit;
import 'package:android_intent_plus/android_intent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'dart:async';

final dbHelper = DBHelper();

Future<void> saveTestResult(double nitrogen, double phosphorus, double potassium) async {
  // Example simple recommendation logic
  String recommendation = "";
  if (nitrogen < 10) recommendation += "Add Nitrogen-rich fertilizer. ";
  if (phosphorus < 10) recommendation += "Add Phosphorus-rich fertilizer. ";
  if (potassium < 10) recommendation += "Add Potassium-rich fertilizer. ";
  if (recommendation.isEmpty) recommendation = "Soil nutrients are balanced.";

  await dbHelper.insertTest({
    "nitrogen": nitrogen,
    "phosphorus": phosphorus,
    "potassium": potassium,
    "date": DateTime.now().toIso8601String(),
    "recommendation": recommendation,
  });
}


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
  const AnalyzerHomePage({super.key});

  @override
  _AnalyzerHomePageState createState() => _AnalyzerHomePageState();
}

class _AnalyzerHomePageState extends State<AnalyzerHomePage> {
  // Nutrient values (initialized as null until loaded from DB)
  double? nitrogen;
  double? phosphorus;
  double? potassium;
  double? acidity;
  String recommendation = "No test results yet.";

  final dbHelper = DBHelper(); // SQLite helper instance

  @override
  void initState() {
    super.initState();
    _loadLatestTest();
  }

  // Load the latest test result from database
  Future<void> _loadLatestTest() async {
    final tests = await dbHelper.getTests();
    if (tests.isNotEmpty) {
      final latest = tests.first; // most recent test
      setState(() {
        nitrogen = latest['nitrogen'];
        phosphorus = latest['phosphorus'];
        potassium = latest['potassium'];
        acidity = latest['acidity'] ?? 0; 
        recommendation = latest['recommendation'];
      });
    }
  }

  // ✅ Main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildDashboardPage(),
    );
  }

  // Dashboard content
  Widget buildDashboardPage() {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFF4FFF4),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ],
            ),

            Center(
              child: Text(
                "HOME PAGE",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nutrient container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  const Text("RECENT FINDINGS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 5),
                  buildNutrientRow("Nitrogen", nitrogen, Colors.green),
                  buildNutrientRow("Phosphorus", phosphorus, Colors.green),
                  buildNutrientRow("Potassium", potassium, Colors.green),
                  buildNutrientRow("Acidity", acidity, Colors.green),
                  const SizedBox(height: 10),
                  Text(
                    "Recommendation: $recommendation",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Field details container (Google Map)
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
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

            const SizedBox(height: 10),

            // Recommendation container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.spa, size: 40, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(recommendation),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable nutrient row widget
  Widget buildNutrientRow(String name, double? value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Text(
          value != null ? value.toStringAsFixed(2) : "N/A",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

   Widget buildNutrientRow(String label, double? value, Color color) {
    if (value == null) return SizedBox.shrink(); // no widget if no data yet
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value / 100, // scale 0–100
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toStringAsFixed(1)),
        ],
      ),
    );
  }

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Define your pages here
  final List<Widget> _pages = [
    MainPage(),       // index 0
    ScanningPage(),   // index 1
    HistoryPage(),    // index 2
    SettingsPage(),   // index 3
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  double? nitrogen;
  double? phosphorus;
  double? potassium;
  double? ph;

  final dbHelper = DBHelper();

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

          // TODO: Replace these with actual sensor values
          nitrogen = 12.5;
          phosphorus = 8.7;
          potassium = 15.2;
          ph = 6.3;

          _saveResults();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Soil analysis complete & saved!')),
          );
        }
      });
    });
  }

  Future<void> _saveResults() async {
    String recommendation = "";
    if ((nitrogen ?? 0) < 10) recommendation += "Add Nitrogen-rich fertilizer. ";
    if ((phosphorus ?? 0) < 10) recommendation += "Add Phosphorus-rich fertilizer. ";
    if ((potassium ?? 0) < 10) recommendation += "Add Potassium-rich fertilizer. ";
    if (recommendation.isEmpty) recommendation = "Soil nutrients are balanced.";

    await dbHelper.insertTest({
      "nitrogen": nitrogen ?? 0,
      "phosphorus": phosphorus ?? 0,
      "potassium": potassium ?? 0,
      "date": DateTime.now().toIso8601String(),
      "recommendation": recommendation,
    });
  }

  Widget buildNutrientRow(String label, double? value, Color color) {
    if (value == null) return SizedBox.shrink();
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
          Text(value.toStringAsFixed(1)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Scanning")),
      body: Center(
        child: isAnalyzing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Analyzing... $countdown s"),
                ],
              )
            : hasAnalyzed
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildNutrientRow("Nitrogen", nitrogen, Colors.green),
                        buildNutrientRow("Phosphorus", phosphorus, Colors.blue),
                        buildNutrientRow("Potassium", potassium, Colors.orange),
                        buildNutrientRow("pH", ph, Colors.purple),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: startAnalysis,
                    child: Text("Start Soil Analysis"),
                  ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage> {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> tests = [];

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    final data = await dbHelper.getTests();
    setState(() {
      tests = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Test History")),
      body: tests.isEmpty
          ? Center(child: Text("No test records found."))
          : ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final item = tests[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("Date: ${item['date']}"),
                    subtitle: Text(
                      "N: ${item['nitrogen']} | "
                      "P: ${item['phosphorus']} | "
                      "K: ${item['potassium']}\n"
                      "Recommendation: ${item['recommendation']}",
                    ),
                  ),
                );
              },
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
                Text("earlcamacho@gmail.com", style: TextStyle(color: Colors.grey[600])),
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

          // About & Support
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
