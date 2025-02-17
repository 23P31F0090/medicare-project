import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicare/location_page.dart';
import 'package:medicare/screens/forgot_password_page.dart';
import 'package:medicare/screens/login_page.dart';
import 'package:medicare/screens/pharmacypage.dart'; // Correct import
import 'package:medicare/screens/registration_page.dart';
import 'package:medicare/screens/splash_screen.dart';
import 'package:medicare/pages/payment_page.dart' as payment_v1; // Import Payment Page
import 'firebase_options.dart';                                             

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      debugPrint("Firebase already initialized");
    }
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCare Plus',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/registration': (context) => RegistrationPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        '/location': (context) => LocationPage(),
        '/pharmacy': (context) => PharmacyPage(),
        '/payment': (context) => payment_v1.PaymentPage(), // Added payment route
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to Home Page'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
                child: const Text('Go to Payment Page'),
              ),
            ],
          ),
        ),
      );
}
