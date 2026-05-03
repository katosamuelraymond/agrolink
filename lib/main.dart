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
    return MaterialApp(
      title: 'AgroLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Deep Green
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFFFA000), // Amber
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
