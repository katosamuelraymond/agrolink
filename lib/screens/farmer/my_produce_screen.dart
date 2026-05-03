import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../models/produce_model.dart';
import '../../widgets/produce_card.dart';

class MyProduceScreen extends StatefulWidget {
  const MyProduceScreen({super.key});

  @override
  State<MyProduceScreen> createState() => _MyProduceScreenState();
}

class _MyProduceScreenState extends State<MyProduceScreen> {
  final _sessionService = SessionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Produce'),
      ),
      body: ValueListenableBuilder<Box<ProduceModel>>(
        valueListenable: Hive.box<ProduceModel>('produce').listenable(),
        builder: (context, box, _) {
          final userId = _sessionService.currentUserId;
          final produceList = box.values.where((p) => p.farmerId == userId).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (produceList.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: produceList.length,
            itemBuilder: (context, index) {
              return ProduceCard(produce: produceList[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Produce Listed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t added any produce yet. Tap the + button to start listing your crops.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
