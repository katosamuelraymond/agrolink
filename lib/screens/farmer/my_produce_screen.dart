import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../models/produce_model.dart';
import '../../widgets/produce_card.dart';
import '../../routes/app_routes.dart';

class MyProduceScreen extends StatefulWidget {
  const MyProduceScreen({super.key});

  @override
  State<MyProduceScreen> createState() => _MyProduceScreenState();
}

class _MyProduceScreenState extends State<MyProduceScreen> {
  final _produceService = ProduceService();
  final _sessionService = SessionService();
  List<ProduceModel> _produceList = [];

  @override
  void initState() {
    super.initState();
    _loadProduce();
  }

  void _loadProduce() {
    final userId = _sessionService.currentUserId;
    if (userId != null) {
      setState(() {
        _produceList = _produceService.getProduceByFarmer(userId)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Produce'),
      ),
      body: _produceList.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async => _loadProduce(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _produceList.length,
                itemBuilder: (context, index) {
                  return ProduceCard(produce: _produceList[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduce).then((_) => _loadProduce()),
        tooltip: 'Add Produce',
        child: const Icon(Icons.add),
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
