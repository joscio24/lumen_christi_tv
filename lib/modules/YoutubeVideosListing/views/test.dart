import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dummy classes for demonstration.
/// Replace these with your own implementations.
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
      height: 150,
      color: Colors.blueGrey,
      child: Image.asset(imageUrl, fit: BoxFit.cover),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.all(5),
      color: Colors.grey[300],
    );
  }
}

class ShimmerCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.grey[300],
    );
  }
}

/// MainScreen: Adjusted to include WillPopScope and a custom BottomNavigationBar.
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  /// Using an RxInt from GetX so that our UI can reactively update.
  final RxInt selectedIndex = 0.obs;

  /// For back-button double-tap exit on the home tab.
  DateTime? lastPressed;

  // Dummy variables to simulate loaded data.
  bool isLoading = false;
  List<dynamic> posts = []; // Replace with your post data.
  List<dynamic> categories = []; // Replace with your category data.

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize categories and posts for demonstration.
    // In your code these would be fetched asynchronously.
    categories = [
      {'name': 'News'},
      {'name': 'Sports'},
      {'name': 'Entertainment'},
    ];
    posts = [
      {
        'title': 'Post One',
        'image': 'https://via.placeholder.com/150',
        'category': 'News',
        'author': 'Author A',
        'date': '2025-01-01'
      },
      {
        'title': 'Post Two',
        'image': 'https://via.placeholder.com/150',
        'category': 'Sports',
        'author': 'Author B',
        'date': '2025-01-02'
      },
      // ... add more posts
    ];

    _tabController =
        TabController(length: categories.isNotEmpty ? categories.length : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// This method intercepts the system back button.
  Future<bool> _onWillPop() async {
    // If the user is on the home tab (index 0), then intercept back-button press.
    if (selectedIndex.value == 0) {
      final DateTime now = DateTime.now();
      if (lastPressed == null ||
          now.difference(lastPressed!) > const Duration(seconds: 2)) {
        lastPressed = now;
        Get.snackbar(
          "Exit",
          "Press back again to exit",
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

  /// Dummy bookmark toggle method.
  void toggleBookmark(dynamic item) {
    // Implement your bookmark logic here.
  }

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
            height: 70.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LiveStreamCard(imageUrl: 'assets/images/demo/demo1.png'),
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
                            return const Center(child: CircularProgressIndicator());
                          }
                          bool isBookmarked = snapshot.data!
                              .any((b) => b.title == item['title']);
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 145,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    (item['image'] != null && item['image']!.isNotEmpty)
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
                                      Colors.transparent
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Get.toNamed('/details',
                                          arguments: item),
                                      child: const CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.play_arrow,
                                            color: Colors.black, size: 20.0),
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
                                          color: Colors.white),
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
                                                height: 20),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item['author'] ?? "Unknown",
                                                  style: const TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              Text(item['date'] ?? "Unknown",
                                                  style: const TextStyle(
                                                      fontSize: 8.0,
                                                      color: Colors.white)),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                    (item['image'] != null && item['image']!.isNotEmpty)
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
                                      Colors.transparent
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Get.toNamed('/details',
                                          arguments: item),
                                      child: const CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.play_arrow,
                                            color: Colors.black, size: 20.0),
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
                                          color: Colors.white),
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
                                                height: 20),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item['author'] ?? "Unknown",
                                                  style: const TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              Text(item['date'] ?? "Unknown",
                                                  style: const TextStyle(
                                                      fontSize: 8.0,
                                                      color: Colors.white)),
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
                SizedBox(
                  child: isLoading
                      ? null
                      : TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: const Color.fromARGB(255, 55, 55, 55),
                          unselectedLabelColor:
                              const Color.fromARGB(255, 98, 98, 98),
                          indicatorColor: Colors.transparent,
                          tabs: categories.isNotEmpty
                              ? categories
                                  .map((category) => Tab(
                                        text: category['name'].toString(),
                                      ))
                                  .toList()
                              : [const Tab(text: 'Loading...')],
                        ),
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: categories.isNotEmpty
                        ? categories.map((category) {
                            if (isLoading) return ShimmerCard2();
                            final filteredData = posts
                                .where((item) =>
                                    item['category'] == category['name'])
                                .toList();
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: filteredData.map((item) {
                                    return Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed('/details',
                                              arguments: item);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                ),
                                                child: item['image']!
                                                        .toString()
                                                        .startsWith("http")
                                                    ? Image.network(
                                                        item['image']!,
                                                        fit: BoxFit.cover,
                                                        width: 80,
                                                        height: 80,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            "assets/images/default.jpg",
                                                            fit: BoxFit.cover,
                                                            width: 80,
                                                            height: 80,
                                                          );
                                                        },
                                                      )
                                                    : Image.asset(
                                                        item['image']!,
                                                        fit: BoxFit.cover,
                                                        width: 80,
                                                        height: 80,
                                                      ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['title']!,
                                                      style:
                                                          const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 12,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: ClipOval(
                                                            child: Image.asset(
                                                              "assets/images/logo_icon.png",
                                                              fit: BoxFit.cover,
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                item['author']!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Text(
                                                                item['date']!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 8.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          child: const Icon(
                                                            Icons
                                                                .bookmark_outline,
                                                            color: Colors.black,
                                                            size: 16.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }).toList()
                        : [ShimmerCard2()],
                  ),
                )
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
                  Get.toNamed('/add');
                  break;
                case 2:
                  Get.toNamed('/bookmark');
                  break;
                case 3:
                  Get.toNamed('/profile');
                  break;
                default:
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  decoration: selectedIndex.value == 0
                      ? const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle)
                      : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.home,
                      size: 30.0,
                      color: selectedIndex.value == 0
                          ? Colors.black
                          : Colors.white),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: selectedIndex.value == 1
                      ? const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle)
                      : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.add_box_outlined,
                      size: 30.0,
                      color: selectedIndex.value == 1
                          ? Colors.black
                          : Colors.white),
                ),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: selectedIndex.value == 2
                      ? const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle)
                      : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.bookmark_border,
                      size: 30.0,
                      color: selectedIndex.value == 2
                          ? Colors.black
                          : Colors.white),
                ),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: selectedIndex.value == 3
                      ? const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle)
                      : null,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.person_outline,
                      size: 30.0,
                      color: selectedIndex.value == 3
                          ? Colors.black
                          : Colors.white),
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
