import 'package:flutter/material.dart';

void main() {
  runApp(const ManageTestsApp());
}

class ManageTestsApp extends StatelessWidget {
  const ManageTestsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
      ),
      darkTheme: ThemeData.dark(),
      home: const ManageTestsScreen(),
    );
  }
}

/* ---------------- DATA MODEL ---------------- */

class LabTest {
  String name;
  String labId;
  int yourPrice;
  int customerPrice;
  bool active;
  IconData icon;

  LabTest({
    required this.name,
    required this.labId,
    required this.yourPrice,
    required this.customerPrice,
    required this.active,
    required this.icon,
  });
}

/* ---------------- SCREEN ---------------- */

class ManageTestsScreen extends StatefulWidget {
  const ManageTestsScreen({super.key});

  @override
  State<ManageTestsScreen> createState() => _ManageTestsScreenState();
}

class _ManageTestsScreenState extends State<ManageTestsScreen> {
  int selectedTab = 0;
  String search = "";

  final List<LabTest> tests = [
    LabTest(
        name: "Complete Blood Count (CBC)",
        labId: "20491",
        yourPrice: 498,
        customerPrice: 500,
        active: true,
        icon: Icons.science),
    LabTest(
        name: "Lipid Profile",
        labId: "20498",
        yourPrice: 748,
        customerPrice: 750,
        active: true,
        icon: Icons.monitor_heart),
    LabTest(
        name: "HbA1c (Glycated Hb)",
        labId: "31052",
        yourPrice: 598,
        customerPrice: 600,
        active: false,
        icon: Icons.bloodtype),
    LabTest(
        name: "Liver Function Test (LFT)",
        labId: "20492",
        yourPrice: 848,
        customerPrice: 850,
        active: true,
        icon: Icons.health_and_safety),
  ];

  List<LabTest> get filteredTests {
    return tests.where((t) {
      final matchesSearch =
      t.name.toLowerCase().contains(search.toLowerCase());
      final matchesTab = selectedTab == 0 ||
          (selectedTab == 1 && t.active) ||
          (selectedTab == 2 && !t.active);
      return matchesSearch && matchesTab;
    }).toList();
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _searchBar(),
          _tabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTests.length,
              itemBuilder: (_, i) => _testCard(filteredTests[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: _fab(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /* ---------------- WIDGETS ---------------- */

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFF6F8F6),
      title: const Text("Manage Tests & Pricing",
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: const Icon(Icons.arrow_back_ios),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Center(
              child: Text("Bulk",
                  style: TextStyle(
                      color: Color(0xFF13EC5B),
                      fontWeight: FontWeight.bold))),
        )
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => setState(() => search = v),
        decoration: InputDecoration(
          hintText: "Search tests by name...",
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF13EC5B), // 💚 green search icon
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }


  Widget _tabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _tab("All Tests", 0),
        _tab("Active", 1),
        _tab("Inactive", 2),
      ],
    );
  }

  Widget _tab(String title, int index) {
    final active = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.black : Colors.grey)),
          ),
          if (active)
            Container(
              height: 3,
              width: 40,
              color: const Color(0xFF13EC5B),
            )
        ],
      ),
    );
  }

  Widget _testCard(LabTest test) {
    return Opacity(
      opacity: test.active ? 1 : 0.6,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13EC5B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                    Icon(test.icon, color: const Color(0xFF13EC5B)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(test.name,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Lab ID: ${test.labId}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Switch(
                    value: test.active,
                    activeColor: const Color(0xFF13EC5B),
                    onChanged: (v) => setState(() => test.active = v),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _priceBox(
                      "Your Price",
                      test.yourPrice,
                      editable: true,
                      onEdit: () => _editPrice(test)),
                  const SizedBox(width: 12),
                  _priceBox("Customer Price", test.customerPrice),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceBox(String title, int price,
      {bool editable = false, VoidCallback? onEdit}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Row(
              children: [
                Text("₹$price",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                if (editable)
                  IconButton(
                      icon: const Icon(Icons.edit,
                          size: 18, color: Color(0xFF13EC5B)),
                      onPressed: onEdit)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF13EC5B),
      onPressed: () {},
      icon: const Icon(Icons.add, color: Colors.black),
      label: const Text("ADD NEW TEST",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // ⭐ IMPORTANT
      currentIndex: 1,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF13EC5B),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: "Tests",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }


  /* ---------------- LOGIC ---------------- */

  void _editPrice(LabTest test) {
    final controller = TextEditingController(text: test.yourPrice.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Price"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  test.yourPrice = int.parse(controller.text);
                  test.customerPrice = test.yourPrice + 2;
                });
                Navigator.pop(context);
              },
              child: const Text("Save")),
        ],
      ),
    );
  }
}
