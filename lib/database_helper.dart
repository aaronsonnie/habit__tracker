import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/habit.dart';

class DatabaseHelper {
  static final _databaseName = "HabitDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'habits';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database instance
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            startDate TEXT,
            endDate TEXT,
            isCompleted INTEGER NOT NULL
          )
          ''');
  }

  // Insert a habit
  Future<int> insertHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.insert(table, habit.toMap());
  }

  // Retrieve all habits
  Future<List<Habit>> getHabits() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  // Update a habit
  Future<int> updateHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.update(
      table,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // Delete a habit
  Future<int> deleteHabit(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
