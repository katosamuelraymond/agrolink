import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _paymentService = PaymentService();
  
  String _selectedMethod = 'MTN MoMo';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final currencyFormat = NumberFormat.currency(symbol: 'UGX ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Make Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.payment, size: 64, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              'Total Amount Due',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(order.totalPrice),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile('MTN MoMo', Icons.phone_android),
            _buildPaymentMethodTile('Airtel Money', Icons.phone_android),
            _buildPaymentMethodTile('Bank Transfer', Icons.account_balance),
            _buildPaymentMethodTile('Cash', Icons.money),
            const SizedBox(height: 24),
            if (_selectedMethod == 'MTN MoMo' || _selectedMethod == 'Airtel Money')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '${_selectedMethod} Number',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              )
            else if (_selectedMethod == 'Bank Transfer')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Bank Account Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Account Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () async {
                      setState(() => _isProcessing = true);
                      
                      // Mock network delay
                      await Future.delayed(const Duration(seconds: 2));
                      
                      await _paymentService.recordPayment(
                        orderId: order.id,
                        amount: order.totalPrice,
                        method: _selectedMethod.toLowerCase().replaceAll(' ', '_'),
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Successful!')),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Payment', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(String title, IconData fallbackIcon) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: _selectedMethod,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedMethod = value;
          });
        }
      },
      secondary: Icon(fallbackIcon, color: Theme.of(context).colorScheme.primary),
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
