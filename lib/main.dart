import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
        ChangeNotifierProvider<NetworkStatus>(
          create: (_) => NetworkStatus(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, NetworkStatus>(
      builder: (context, themeManager, networkStatus, child) {
        return MaterialApp(
          title: 'Tab Navigation Drawer',
          theme:
              themeManager.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: MyHomePage(networkStatus: networkStatus),
          routes: {
            SignInScreen.routeName: (context) => SignInScreen(),
            SignUpScreen.routeName: (context) => SignUpScreen(),
            GalleryScreen.routeName: (context) => GalleryScreen(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final NetworkStatus networkStatus;

  MyHomePage({required this.networkStatus});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tab Navigation Drawer'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Calculator'),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, GalleryScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.brightness_4),
                title: Text('Dark Theme'),
                trailing: Switch(
                  value: themeManager.isDarkTheme,
                  onChanged: (value) {
                    themeManager.toggleTheme();
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Sign In'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Sign Up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeScreen(networkStatus: widget.networkStatus),
            CalculatorScreen(),
            SettingsScreen(),
            ProfileScreen(),
            NotificationsScreen(),
            GalleryScreen(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.calculate),
                text: 'Calculator',
              ),
              Tab(
                icon: Icon(Icons.browse_gallery),
                text: 'Gallery',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeManager with ChangeNotifier {
  late bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeManager() {
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}

class NetworkStatus with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void updateNetworkStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Container(
      child: Text(networkStatus.isConnected ? 'Connected' : 'Disconnected'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final NetworkStatus networkStatus;

  HomeScreen({required this.networkStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWidget()),
                );
              },
              child: Text('Open MyWidget'),
            ),
            SizedBox(height: 20),
            Text(
              networkStatus.isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  static const routeName = '/signIn';

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // Implement sign-in logic here
    } catch (error) {
      // Handle sign-in error
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    // Implement sign-in logic with username and password here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text('Sign In'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text('Sign In with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUp';
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // Implement sign-up logic here
    } catch (error) {
      // Handle sign-up error
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Implement sign-up logic with username, password, and confirm password here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signUpWithGoogle,
                child: Text('Sign Up with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
