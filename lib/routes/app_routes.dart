import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/farmer/farmer_dashboard.dart';
import '../screens/farmer/farmer_main.dart';
import '../screens/farmer/add_produce_screen.dart';
import '../screens/farmer/my_produce_screen.dart';
import '../screens/farmer/order_requests_screen.dart';
import '../screens/farmer/logistics_status_screen.dart';
import '../screens/buyer/buyer_dashboard.dart';
import '../screens/buyer/buyer_main.dart';
import '../screens/buyer/browse_produce_screen.dart';
import '../screens/buyer/my_orders_screen.dart';
import '../screens/buyer/payment_screen.dart';
import '../screens/transporter/transporter_dashboard.dart';
import '../screens/transporter/transporter_main.dart';
import '../screens/transporter/available_pickups_screen.dart';
import '../screens/transporter/my_deliveries_screen.dart';
import '../screens/shared/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  static const String farmerDashboard = '/farmer_dashboard';
  static const String addProduce = '/add_produce';
  static const String myProduce = '/my_produce';
  static const String orderRequests = '/order_requests';
  static const String logisticsStatus = '/logistics_status';

  static const String buyerDashboard = '/buyer_dashboard';
  static const String browseProduce = '/browse_produce';
  static const String myOrders = '/my_orders';
  static const String payment = '/payment';

  static const String transporterDashboard = '/transporter_dashboard';
  static const String availablePickups = '/available_pickups';
  static const String myDeliveries = '/my_deliveries';

  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        
        farmerDashboard: (context) => const FarmerMainScreen(),
        addProduce: (context) => const AddProduceScreen(),
        myProduce: (context) => const MyProduceScreen(),
        orderRequests: (context) => const OrderRequestsScreen(),
        logisticsStatus: (context) => const LogisticsStatusScreen(),
        
        buyerDashboard: (context) => const BuyerMainScreen(),
        browseProduce: (context) => const BrowseProduceScreen(),
        myOrders: (context) => const MyOrdersScreen(),
        payment: (context) => const PaymentScreen(),
        
        transporterDashboard: (context) => const TransporterMainScreen(),
        availablePickups: (context) => const AvailablePickupsScreen(),
        myDeliveries: (context) => const MyDeliveriesScreen(),
        profile: (context) => const ProfileScreen(),
      };
}
