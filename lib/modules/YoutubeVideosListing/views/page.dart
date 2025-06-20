import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'video_list_page.dart';

const String apiKey = "YOUR_YOUTUBE_API_KEY";
const String channelId = "YOUR_CHANNEL_ID";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final String url =
        "https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet&type=video&maxResults=10";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'];
        setState(() {
          videos = items.map((item) {
            return {
              "title": item['snippet']['title'] ?? "No Title",
              "videoId": item['id']['videoId'] ?? "",
              "thumbnail": item['snippet']['thumbnails']['medium']['url'] ?? "",
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw "Failed to load videos";
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lumen Christi TV")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vidéos Lumen Christi TV", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllVideosPage()),
                    );
                  },
                  child: Text("See All", style: TextStyle(fontSize: 16, color: Colors.blue)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final item = videos[index];
                      return Container(
                        width: 145,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item['thumbnail']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                            onPressed: () {
                              // Navigate to video player page
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
