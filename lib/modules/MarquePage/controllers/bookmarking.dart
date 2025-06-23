import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BookmarkDB {
  static final BookmarkDB instance = BookmarkDB._init();

  static Database? _database;

  BookmarkDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE bookmarks (
        id $idType,
        postId INTEGER NOT NULL UNIQUE,
        title $textType,
        author $textType,
        date $textType,
        imageUrl $textType
      )
    ''');
  }

  Future<void> insertBookmark(Map<String, dynamic> post) async {
    final db = await instance.database;

    final bookmark = {
      'postId': post['id'],
      'title': post['title']['rendered'] ?? '',
      'author': post['_embedded']?['author']?[0]?['name'] ?? 'Unknown',
      'date': post['date'] ?? '',
      'imageUrl': post['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '',
    };

    await db.insert(
      'bookmarks',
      bookmark,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(int postId) async {
    final db = await instance.database;

    await db.delete(
      'bookmarks',
      where: 'postId = ?',
      whereArgs: [postId],
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await instance.database;

    return await db.query('bookmarks');
  }

  Future<bool> isBookmarked(int postId) async {
    final db = await instance.database;

    final maps = await db.query(
      'bookmarks',
      columns: ['postId'],
      where: 'postId = ?',
      whereArgs: [postId],
      limit: 1,
    );

    return maps.isNotEmpty;
  }
}
