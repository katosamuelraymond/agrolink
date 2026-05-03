import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/farmer/farmer_dashboard.dart';
import '../screens/farmer/add_produce_screen.dart';
import '../screens/farmer/my_produce_screen.dart';
import '../screens/farmer/order_requests_screen.dart';
import '../screens/farmer/logistics_status_screen.dart';
import '../screens/buyer/buyer_dashboard.dart';
import '../screens/buyer/browse_produce_screen.dart';
import '../screens/buyer/my_orders_screen.dart';
import '../screens/buyer/payment_screen.dart';
import '../screens/transporter/transporter_dashboard.dart';

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

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        
        farmerDashboard: (context) => const FarmerDashboard(),
        addProduce: (context) => const AddProduceScreen(),
        myProduce: (context) => const MyProduceScreen(),
        orderRequests: (context) => const OrderRequestsScreen(),
        logisticsStatus: (context) => const LogisticsStatusScreen(),
        
        buyerDashboard: (context) => const BuyerDashboard(),
        browseProduce: (context) => const BrowseProduceScreen(),
        myOrders: (context) => const MyOrdersScreen(),
        payment: (context) => const PaymentScreen(),
        
        transporterDashboard: (context) => const TransporterDashboard(),
      };
}
