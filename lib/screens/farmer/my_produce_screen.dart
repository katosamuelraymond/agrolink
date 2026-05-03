import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../models/produce_model.dart';
import '../../widgets/produce_card.dart';
import 'edit_produce_screen.dart';

class MyProduceScreen extends StatelessWidget {
  const MyProduceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    final produceService = ProduceService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Produce'),
      ),
      body: ValueListenableBuilder<Box<ProduceModel>>(
        valueListenable: Hive.box<ProduceModel>('produce').listenable(),
        builder: (context, box, _) {
          final userId = sessionService.currentUserId;
          final produceList = box.values.where((p) => p.farmerId == userId).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (produceList.isEmpty) {
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
                      'Tap the + button to start listing your crops.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: produceList.length,
            itemBuilder: (context, index) {
              final produce = produceList[index];
              return ProduceCard(
                produce: produce,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProduceScreen(produce: produce)),
                ),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Produce'),
                      content: Text('Are you sure you want to delete "${produce.cropName}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await produceService.deleteProduce(produce.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produce deleted.')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
