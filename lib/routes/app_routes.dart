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
import '../screens/transporter/available_pickups_screen.dart';
import '../screens/transporter/my_deliveries_screen.dart';

import '../screens/shared/profile_screen.dart';
import '../screens/shared/notifications_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  static const String farmerDashboard = '/farmer/dashboard';
  static const String addProduce = '/farmer/add_produce';
  static const String myProduce = '/farmer/my_produce';
  static const String orderRequests = '/farmer/order_requests';
  static const String logisticsStatus = '/farmer/logistics_status';
  
  static const String buyerDashboard = '/buyer/dashboard';
  static const String browseProduce = '/buyer/browse_produce';
  static const String myOrders = '/buyer/my_orders';
  static const String payment = '/buyer/payment';
  
  static const String transporterDashboard = '/transporter/dashboard';
  static const String availablePickups = '/transporter/available_pickups';
  static const String myDeliveries = '/transporter/my_deliveries';
  
  static const String profile = '/shared/profile';
  static const String notifications = '/shared/notifications';

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
        availablePickups: (context) => const AvailablePickupsScreen(),
        myDeliveries: (context) => const MyDeliveriesScreen(),
        
        profile: (context) => const ProfileScreen(),
        notifications: (context) => const NotificationsScreen(),
      };
}
