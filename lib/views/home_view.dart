import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lumen_christi_tv/widget/shimmer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class Bookmark {
  final String title;
  Bookmark({required this.title});
}

class BookmarkDB {
  BookmarkDB._();
  static final BookmarkDB instance = BookmarkDB._();
  Future<List<Bookmark>> getBookmarks() async {
    // Replace with your actual database code.
    await Future.delayed(const Duration(milliseconds: 500));
    return [Bookmark(title: 'Example')];
  }
}

class LiveStreamCard extends StatelessWidget {
  final String imageUrl;
  const LiveStreamCard({Key? key, required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(20)),

        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(5, 05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Stack(
        children: [
          Center(
            child: Container(
              child: IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.play_circle_outline_outlined,
                  size: 70,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(05, 05),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: 70,
              height: 25,
              padding: EdgeInsets.all(02),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "LIVE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
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

  late TabController _tabController;

  /// Using an RxInt from GetX so that our UI can reactively update.
  final RxInt selectedIndex = 0.obs;

  /// For back-button double-tap exit on the home tab.
  DateTime? lastPressed;

  // Dummy variables to simulate loaded data.
  bool isLoading = true;
  List<dynamic> posts = []; // Replace with your post data.
  List<dynamic> videos = []; // Replace with your post data.
  List<dynamic> categories = []; // Replace with your category data.

  /// Dummy bookmark toggle method.
  void toggleBookmark(dynamic item) {
    // Implement your bookmark logic here.
  }
  final String apiKey = "";
  final String channelId = "";

  Future<bool> _onWillPop() async {
    // If the user is on the home tab (index 0), then intercept back-button press.
    if (selectedIndex.value == 0) {
      final DateTime now = DateTime.now();
      if (lastPressed == null ||
          now.difference(lastPressed!) > const Duration(seconds: 2)) {
        lastPressed = now;
        Get.snackbar(
          "Quitter l'application ?",
          "Appuyez a nouveau pour quitter l'app",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
        return false; // Do not pop the route
      }
      return true; // Exit the app
    }
    // For other tabs, you might allow normal back behavior.
    return true;
  }

  Future<void> fetchCategories() async {
    try {
      await Future.delayed(
        Duration(seconds: 2),
      ); // Simulating delay for fetching
      final response = await http.get(
        Uri.parse("https://lumenchristitv.com/wp-json/wp/v2/categories"),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Define allowed categories
        List<String> allowedCategories = [
          "Témoignage",
          "Reportage",
          "Prières",
          "Documentaire",
          "Entretien",
          "Émission spéciale",
          "Culture",
        ];

        List<Map<String, dynamic>> fetchedCategories =
            data
                .map((category) {
                  return {
                    "id": category["id"] ?? 0,
                    "name": category["name"]?.toString() ?? "Unknown",
                    "count": category["count"] ?? 0,
                  };
                })
                .where(
                  (category) => allowedCategories.contains(category["name"]),
                )
                .toList();

        setState(() {
          categories = fetchedCategories;
          isLoading = false;
          _tabController.dispose();
          _tabController = TabController(
            length: categories.length,
            vsync: this,
          );
        });
      } else {
        print("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchVideos() async {
    final String url =
        "https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet&type=video&maxResults=100";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(jsonEncode(response.body));

        final data = json.decode(response.body);

        final List items = data['items'];

        setState(() {
          videos =
              items.map((item) {
                return {
                  "title": (item['snippet']['title'] ?? "No Title").toString(),

                  "videoId": (item['id']['videoId'] ?? "").toString(),

                  "thumbnail":
                      (item['snippet']['thumbnails']['medium']['url'] ?? "")
                          .toString(),

                  "description":
                      (item['snippet']['description'] ?? "No Description")
                          .toString(),

                  "date":
                      (item['snippet']['publishedAt'] ?? "Unknown Date")
                          .toString(),

                  "author":
                      (item['snippet']['channelTitle'] ?? "Unknown Author")
                          .toString(),
                };
              }).toList();
        });
      } else {
        throw "Failed to load videos";
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // List<Map<String, String>> _filterDataByCategory(String category) {
  //   return sampleData
  //       .where(
  //         (item) => item['category']!.toLowerCase() == category.toLowerCase(),
  //       )
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/lumen_christi_logo.png', // Your logo asset path
            height: 60.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LiveStreamCard(imageUrl: 'assets/images/live_bg.jpg'),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Vidéos YouTube . . .",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      TextButton(onPressed: () => {}, child: const Text(
                        "Voir tout",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),)
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Horizontal List 1
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 5 : videos.length,
                    itemBuilder: (context, index) {
                      if (isLoading) return ShimmerCard();
                      final item = posts[index];
                      return FutureBuilder<List<Bookmark>>(
                        future: BookmarkDB.instance.getBookmarks(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          bool isBookmarked = snapshot.data!.any(
                            (b) => b.title == item['title'],
                          );
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 145,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    (item['image'] != null &&
                                            item['image']!.isNotEmpty)
                                        ? item['image']!
                                        : "assets/images/default.jpg",
                                  ),
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
                              child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        item['category'] ?? "Uncategorized",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap:
                                          () => Get.toNamed(
                                            '/details',
                                            arguments: item,
                                          ),
                                      child: const CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['title'] ?? "No Title",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.3,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/logo_icon.png",
                                              fit: BoxFit.cover,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['author'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                item['date'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => toggleBookmark(item),
                                          child: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            color: Colors.white,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "A la Une . . .",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                // Horizontal List 1
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 5 : posts.length,
                    itemBuilder: (context, index) {
                      if (isLoading) return ShimmerCard();
                      final item = posts[index];
                      return FutureBuilder<List<Bookmark>>(
                        future: BookmarkDB.instance.getBookmarks(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          bool isBookmarked = snapshot.data!.any(
                            (b) => b.title == item['title'],
                          );
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 145,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    (item['image'] != null &&
                                            item['image']!.isNotEmpty)
                                        ? item['image']!
                                        : "assets/images/default.jpg",
                                  ),
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
                              child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        item['category'] ?? "Uncategorized",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap:
                                          () => Get.toNamed(
                                            '/details',
                                            arguments: item,
                                          ),
                                      child: const CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['title'] ?? "No Title",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.3,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/logo_icon.png",
                                              fit: BoxFit.cover,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['author'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                item['date'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => toggleBookmark(item),
                                          child: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            color: Colors.white,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "Dernières parutions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                // Horizontal List 2
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 5 : posts.length,
                    itemBuilder: (context, index) {
                      if (isLoading) return ShimmerCard();
                      final item = posts[index];
                      return FutureBuilder<List<Bookmark>>(
                        future: BookmarkDB.instance.getBookmarks(),
                        builder: (context, snapshot) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 145,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    (item['image'] != null &&
                                            item['image']!.isNotEmpty)
                                        ? item['image']!
                                        : "assets/images/default.jpg",
                                  ),
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
                              child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        item['category'] ?? "Uncategorized",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap:
                                          () => Get.toNamed(
                                            '/details',
                                            arguments: item,
                                          ),
                                      child: const CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['title'] ?? "No Title",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.3,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/logo_icon.png",
                                              fit: BoxFit.cover,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['author'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                item['date'] ?? "Unknown",
                                                style: const TextStyle(
                                                  fontSize: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => toggleBookmark(item),
                                          child: const Icon(
                                            Icons.bookmark_outline,
                                            color: Colors.white,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // TabBar Section
              ],
            ),
          ),
        ),
        // Custom BottomNavigationBar with active icon styling.
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: Colors.black,
            // Because we’re decorating the active icon’s container,
            // we set the selectedItemColor to black so that the active icon appears in black
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex.value,
            onTap: (index) {
              selectedIndex.value = index;
              switch (index) {
                case 0:
                  Get.toNamed('/home');
                  break;

                case 1:
                  Get.toNamed('/bookmark');
                  break;
                case 2:
                  Get.toNamed('/profile');
                  break;
                default:
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  decoration:
                      selectedIndex.value == 0
                          ? const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          )
                          : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.home,
                    size: 30.0,
                    color:
                        selectedIndex.value == 0 ? Colors.black : Colors.white,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration:
                      selectedIndex.value == 2
                          ? const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          )
                          : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 30.0,
                    color:
                        selectedIndex.value == 2 ? Colors.black : Colors.white,
                  ),
                ),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration:
                      selectedIndex.value == 3
                          ? const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          )
                          : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.person_outline,
                    size: 30.0,
                    color:
                        selectedIndex.value == 3 ? Colors.black : Colors.white,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
