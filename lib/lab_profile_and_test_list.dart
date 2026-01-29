import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LabProfileScreen(),
    );
  }
}

class LabProfileScreen extends StatefulWidget {
  const LabProfileScreen({super.key});

  @override
  State<LabProfileScreen> createState() => _LabProfileScreenState();
}

class _LabProfileScreenState extends State<LabProfileScreen> {
  static const primary = Color(0xFF137FEC);
  static const muted = Color(0xFF4C739A);

  List<dynamic> tests = [];
  Map<String, int> cart = {};

  @override
  void initState() {
    super.initState();
    loadTests();
  }

  Future<void> loadTests() async {
    final data = await rootBundle.loadString('assets/lab_tests.json');
    setState(() {
      tests = json.decode(data);
    });
  }

  int get totalItems => cart.values.fold(0, (a, b) => a + b);

  int get totalPrice => cart.entries.fold<int>(
    0,
        (sum, e) {
      final test = tests.firstWhere((t) => t['title'] == e.key);
      final price = (test['price'] as num).toInt();
      return sum + (price * e.value);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Profile"),
        centerTitle: true,
      ),
      body: tests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: tests.length,
            itemBuilder: (context, i) {
              final t = tests[i];
              return _buildTestCard(t);
            },
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _buildTestCard(dynamic t) {
    int qty = cart[t['title']] ?? 0;
    int price = (t['price'] as num).toInt();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(t['desc'], style: const TextStyle(color: Colors.grey)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹$price",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
              qty == 0
                  ? ElevatedButton(
                onPressed: () => setState(() => cart[t['title']] = 1),
                child: const Text("Add to Cart"),
              )
                  : Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      qty > 1 ? cart[t['title']] = qty - 1 : cart.remove(t['title']);
                    }),
                  ),
                  Text(qty.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => cart[t['title']] = qty + 1),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹$totalPrice  |  $totalItems Tests"),
            ElevatedButton(onPressed: () {}, child: const Text("Proceed")),
          ],
        ),
      ),
    );
  }
}
