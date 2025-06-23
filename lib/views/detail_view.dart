import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:lumen_christi_tv/modules/MarquePage/controllers/bookmarking.dart';
import 'package:share_plus/share_plus.dart';
class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late final Map<String, dynamic> item;

  bool get isBookmarked => false;

  @override
  void initState() {
    super.initState();

    // Get the passed argument (assumed to be a Map<String, dynamic>)
    item = Get.arguments ?? {};
  }

  void toggleBookmark(Map<String, dynamic> post) async {
    final postId = post['id'] as int;

    final isBookmarked = await BookmarkDB.instance.isBookmarked(postId);

    if (isBookmarked) {
      await BookmarkDB.instance.deleteBookmark(postId);
      print('Removed bookmark: $postId');
    } else {
      await BookmarkDB.instance.insertBookmark(post);
      print('Added bookmark: $postId');
    }

    // Optionally, refresh your UI to reflect bookmark state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = "assets/images/live_bg.jpg";
    if (item['_embedded'] != null &&
        item['_embedded']['wp:featuredmedia'] != null &&
        (item['_embedded']['wp:featuredmedia'] as List).isNotEmpty) {
      imageUrl =
          item['_embedded']['wp:featuredmedia'][0]['source_url'] ?? imageUrl;
    }

    List categories = [];
    if (item['_embedded'] != null && item['_embedded']['wp:term'] != null) {
      categories = item['_embedded']['wp:term'][0]; // categories are at index 0
    }

    String categoryName = "Uncategorized";

    if (categories.isNotEmpty) {
      categoryName = categories[0]['name'] ?? "Uncategorized";
    }

    String authorName = "Unknown";

    if (item['_embedded'] != null && item['_embedded']['author'] != null) {
      final authors = item['_embedded']['author'] as List;
      if (authors.isNotEmpty) {
        authorName = authors[0]['name'] ?? "Unknown";
      }
    }

    // You'll need to fetch author details separately if needed
    String date = item['date']?.substring(0, 10) ?? "Unknown";
    String title = item['title']?['rendered'] ?? 'No Title';

    return Scaffold(
      body: Stack(
        children: [
          // Video container at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.play_circle_outline_outlined,
                        size: 70,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Material(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom drawer sheet with title header, always visible
          DraggableScrollableSheet(
            initialChildSize: 0.7, // start height (40% screen)
            minChildSize: 0.7,
            maxChildSize: 0.71,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    // Drawer header with title and close button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () => toggleBookmark(item),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable content below header
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Html(data: item['content']?['rendered'] ?? ''),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        
                        color: Color.fromARGB(255, 234, 234, 234),
                      ),
                      child: PostInfoRow(item: item)
),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    // body: Container(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Example: show image if exists
    //       Image.network(imageUrl),

    //       const SizedBox(height: 12),

    //       Text(
    //         title,
    //         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //       ),

    //       const SizedBox(height: 8),

    //       Text('Author: $authorName', style: const TextStyle(fontSize: 16)),

    //       const SizedBox(height: 8),

    //       Text(
    //         'Date: $date',
    //         style: const TextStyle(fontSize: 14, color: Colors.grey),
    //       ),

    //       const SizedBox(height: 16),

    //       // If you have content or description field
    //       if (item['content'] != null)
    //         Expanded(
    //           child: SingleChildScrollView(
    //             child: Html(data: item['content']['rendered'] ?? ''),
    //           ),
    //         ),
    //     ],
    //   ),
    // ),
  }


}



  class PostInfoRow extends StatefulWidget {
  final Map<String, dynamic> item;
  const PostInfoRow({Key? key, required this.item}) : super(key: key);

  @override
  State<PostInfoRow> createState() => _PostInfoRowState();
}

class _PostInfoRowState extends State<PostInfoRow> {
  int commentCount = 0;
  bool isLoadingComments = true;

  @override
  void initState() {
    super.initState();
    fetchCommentCount();
  }

  Future<void> fetchCommentCount() async {
    final postId = widget.item['id'];
    if (postId == null) return;

    final url = Uri.parse('https://lumenchristitv.com/wp-json/wp/v2/comments?post=$postId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response);
        final List comments = jsonDecode(response.body);
        setState(() {
          commentCount = comments.length;
          isLoadingComments = false;
        });
      }
    } catch (e) {
      setState(() {
        commentCount = 0;
        isLoadingComments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postUrl = widget.item['link'] ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Comments count
        Row(
          children: [
            const Icon(Icons.comment, color: Colors.black54, size: 18),
            const SizedBox(width: 4),
            isLoadingComments
                ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black54),
                  )
                : Text(
                    '$commentCount',
                    style: const TextStyle(color: Colors.black54),
                  ),
          ],
        ),

        // Views count (if you have it, else remove or set 0)
        Row(
          children: [
            const Icon(Icons.remove_red_eye, color: Colors.black54, size: 18),
            const SizedBox(width: 4),
            Text(
              '${widget.item['viewsCount'] ?? 0}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),

        // Share button
        InkWell(
          onTap: () {
            if (postUrl.isNotEmpty) {
              Share.share(postUrl);
            }
          },
          child: const Icon(
            Icons.share,
            color: Colors.black54,
            size: 22,
          ),
        ),
      ],
    );
  }
}
