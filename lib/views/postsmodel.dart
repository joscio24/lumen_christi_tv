class Post {
  final int id;
  final String title;
  final String? image;
  final String? category;
  final String? author;
  final String? date;

  Post({
    required this.id,
    required this.title,
    this.image,
    this.category,
    this.author,
    this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Extract featured media (image) URL if available
    String? imageUrl;
    try {
      if (json['_embedded'] != null &&
          json['_embedded']['wp:featuredmedia'] != null &&
          json['_embedded']['wp:featuredmedia'].length > 0) {
        imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'];
      }
    } catch (_) {
      imageUrl = null;
    }

    // Extract category name (assuming first category)
    String? categoryName;
    try {
      if (json['_embedded'] != null &&
          json['_embedded']['wp:term'] != null &&
          json['_embedded']['wp:term'][0].length > 0) {
        categoryName = json['_embedded']['wp:term'][0][0]['name'];
      }
    } catch (_) {
      categoryName = null;
    }

    // Extract author name
    String? authorName;
    try {
      if (json['_embedded'] != null &&
          json['_embedded']['author'] != null &&
          json['_embedded']['author'].length > 0) {
        authorName = json['_embedded']['author'][0]['name'];
      }
    } catch (_) {
      authorName = null;
    }

    return Post(
      id: json['id'],
      title: json['title']?['rendered'] ?? "No Title",
      image: imageUrl,
      category: categoryName ?? "Uncategorized",
      author: authorName ?? "Unknown",
      date: json['date'] ?? "Unknown",
    );
  }
}
