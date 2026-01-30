import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
      ),
      home: const LabProfileScreen(),
    );
  }
}

// ---------------- JSON DATA PROVIDER ----------------
class LabDataProvider {
  final Map<String, dynamic> data;
  LabDataProvider(this.data);

  Map<String, dynamic> get profile => data['profile'];
  List<Map<String, dynamic>> get stats =>
      List<Map<String, dynamic>>.from(data['stats']);
  List<Map<String, dynamic>> get tests =>
      List<Map<String, dynamic>>.from(data['tests']);
}

Future<LabDataProvider> loadLabData() async {
  final jsonString = await rootBundle.loadString('assets/lab_profile_and_test_list.json');
  final jsonMap = json.decode(jsonString);
  return LabDataProvider(jsonMap);
}

// ---------------- LAB PROFILE SCREEN ----------------
class LabProfileScreen extends StatefulWidget {
  const LabProfileScreen({super.key});

  static const primary = Color(0xFF137FEC);
  static const darkText = Color(0xFF0D141B);
  static const muted = Color(0xFF4C739A);

  @override
  State<LabProfileScreen> createState() => _LabProfileScreenState();
}

class _LabProfileScreenState extends State<LabProfileScreen> {
  late Future<LabDataProvider> _labDataFuture;
  final Map<int, int> cart = {}; // price -> quantity

  @override
  void initState() {
    super.initState();
    _labDataFuture = loadLabData();
  }

  int get totalItems => cart.values.fold(0, (sum, qty) => sum + qty);
  int get totalPrice => cart.entries.fold(0, (sum, e) => sum + e.key * e.value);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LabDataProvider>(
      future: _labDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final labData = snapshot.data!;
        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _appBar(),
                  SliverToBoxAdapter(child: _profileSection(labData.profile)),
                  SliverToBoxAdapter(child: _statsSection(labData.stats)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchHeader(),
                  ),
                  SliverToBoxAdapter(child: _testList(labData.tests)),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
                ],
              ),
              _bottomBar(),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _appBar() => SliverAppBar(
    pinned: true,
    backgroundColor: Colors.white,
    elevation: 1,
    leading: const Icon(Icons.arrow_back_ios, size: 18),
    title: const Text("Lab Profile", style: TextStyle(fontWeight: FontWeight.bold)),
    centerTitle: false,
    actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.share_outlined))],
  );

  Widget _profileSection(Map profile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: NetworkImage(profile['image']), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(profile['name'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (profile['verified'] == true) const SizedBox(width: 6),
                        if (profile['verified'] == true)
                          const Icon(Icons.verified_outlined,
                              color: LabProfileScreen.primary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("${profile['accreditation']} • ${profile['open_time']}",
                        style: const TextStyle(
                            color: LabProfileScreen.muted, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: LabProfileScreen.muted),
                        const SizedBox(width: 4),
                        Text(profile['address'], style: const TextStyle(color: LabProfileScreen.muted)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _primaryButton(Icons.call, "Call Lab"),
              const SizedBox(width: 12),
              _outlineButton(Icons.directions, "Directions"),
            ],
          )
        ],
      ),
    );
  }

  Widget _statsSection(List<Map<String, dynamic>> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        children: stats.map((s) => _statCard(s['title'], s['value'], s['sub'], _mapIcon(s['icon']))).toList(),
      ),
    );
  }

  Widget _testList(List<Map<String, dynamic>> tests) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: tests.map((test) {
          final price = test["price"] as int;
          final qty = cart[price] ?? 0;
          return TestCard(
            title: test["title"] as String,
            desc: test["desc"] as String,
            price: price,
            quantity: qty,
            onAdd: () => setState(() => cart[price] = 1),
            onInc: () => setState(() => cart[price] = qty + 1),
            onDec: () => setState(() {
              if (qty <= 1) {
                cart.remove(price);
              } else {
                cart[price] = qty - 1;
              }
            }),
          );
        }).toList(),
      ),
    );
  }

  IconData _mapIcon(String icon) {
    switch (icon) {
      case "star":
        return Icons.star_border;
      case "biotech":
        return Icons.biotech;
      case "schedule":
        return Icons.schedule;
      default:
        return Icons.help_outline;
    }
  }

  Widget _primaryButton(IconData icon, String text) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: LabProfileScreen.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(text),
      ),
    );
  }

  Widget _outlineButton(IconData icon, String text) {
    return Expanded(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: LabProfileScreen.primary,
          backgroundColor: LabProfileScreen.primary.withOpacity(.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(text),
      ),
    );
  }

  Widget _statCard(String title, String value, String? sub, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 14, color: LabProfileScreen.muted), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12, color: LabProfileScreen.muted))]),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("$totalItems Test${totalItems > 1 ? 's' : ''} Added",
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("₹$totalPrice", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
            ]),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: LabProfileScreen.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {},
              icon: const Text("Proceed to Pay", style: TextStyle(fontSize: 16, color: Colors.white)),
              label: const Icon(Icons.chevron_right, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- SEARCH HEADER ----------------
class _SearchHeader extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 140;
  @override
  double get maxExtent => 140;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search blood tests, health packages...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                FilterChipWidget("All Tests", true),
                FilterChipWidget("Blood Work", false),
                FilterChipWidget("Radiology", false),
                FilterChipWidget("Health Packages", false),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_) => false;
}

// ---------------- FILTER CHIP ----------------
class FilterChipWidget extends StatelessWidget {
  final String text;
  final bool active;
  const FilterChipWidget(this.text, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: active ? LabProfileScreen.primary : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
    );
  }
}

// ---------------- TEST CARD ----------------
class TestCard extends StatelessWidget {
  final String title;
  final String desc;
  final int price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const TestCard({
    super.key,
    required this.title,
    required this.desc,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: quantity > 0 ? LabProfileScreen.primary : const Color(0xFFE5E7EB), width: quantity > 0 ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: Colors.grey)),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹$price", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: LabProfileScreen.primary)),
              quantity > 0
                  ? Row(children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: onDec),
                Text(quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add), onPressed: onInc),
              ])
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: LabProfileScreen.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                onPressed: onAdd,
                child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }
}
