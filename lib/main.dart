import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user_model.dart';
import 'models/produce_model.dart';
import 'models/order_model.dart';
import 'models/payment_model.dart';
import 'models/logistics_model.dart';

import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProduceModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());
  Hive.registerAdapter(LogisticsModelAdapter());
  
  // Open Boxes
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<ProduceModel>('produce');
  await Hive.openBox<OrderModel>('orders');
  await Hive.openBox<PaymentModel>('payments');
  await Hive.openBox<LogisticsModel>('logistics');
  await Hive.openBox('session');
  
  runApp(const AgroLinkApp());
}

class AgroLinkApp extends StatelessWidget {
  const AgroLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);
    const amber = Color(0xFFFFA000);

    return MaterialApp(
      title: 'AgroLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: amber,
          surface: const Color(0xFFF5F5F5),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        // ── AppBar: Deep green background with white text ──
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        // ── Navigation Bar: Dark green with amber indicator ──
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkGreen,
          indicatorColor: amber.withValues(alpha: 0.25),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: amber);
            }
            return const IconThemeData(color: Colors.white70);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: amber,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }
            return const TextStyle(color: Colors.white60, fontSize: 11);
          }),
        ),
        // ── Cards: slight shadow, off-white surface ──
        cardTheme: CardThemeData(
          elevation: 3,
          surfaceTintColor: Colors.white,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        // ── Scaffold: Light grey background instead of pure white ──
        scaffoldBackgroundColor: const Color(0xFFF0F4F0),
        // ── ElevatedButton: Green by default ──
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        // ── FloatingActionButton ──
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: amber,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
