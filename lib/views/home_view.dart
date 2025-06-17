import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> sampleData = [
    {
      "title": "Vers un second mandat de Talon ?",
      "category": "Politique",
      "date": "22 Aout 2024",
      "author": "Lumen Christi TV",
      "image": "assets/images/demo/demo1.png",
    },
    {
      "title": "Yeezus ou la culture inutile de rien ?",
      "category": "Culture",
      "date": "22 Aout 2024",
      "author": "Magli Degila",
      "image": "assets/images/demo/demo2.png",
    },
    {
      "title": "Une appli pour la mode",
      "category": "Mode",
      "date": "22 Aout 2024",
      "author": "Lumen Christi TV",
      "image": "assets/images/demo/demo3.png",
    },
    {
      "title": "Faire du yoga à Agla",
      "category": "Santé",
      "date": "22 Aout 2024",
      "author": "Lumen Christi TV",
      "image": "assets/images/demo/demo4.png",
    },
  ];

  final List<String> categories = ["Politique", "Santé", "Culture", "Mode"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _filterDataByCategory(String category) {
    return sampleData
        .where((item) => item['category']!.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/lumen_christi_logo.png',
          height: 70.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "A la Une . . .",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sampleData.length,
                itemBuilder: (context, index) {
                  final item = sampleData[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/details', arguments: item);
                    },
                    child: Container(
                      width: 145,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                tabs: categories.map((category) => Tab(text: category)).toList(),
              ),
            ),
            SizedBox(
              height: 300, // Adjust for vertical space
              child: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  final filteredData = _filterDataByCategory(category);
                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return ListTile(
                        leading: Image.asset(item['image']!, fit: BoxFit.cover, width: 50),
                        title: Text(item['title']!),
                        subtitle: Text("${item['author']} - ${item['date']}"),
                        onTap: () {
                          Get.toNamed('/details', arguments: item);
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
