
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../model/task_model.dart';

class TaskDbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(''' 
          CREATE TABLE tasks( 
            id TEXT PRIMARY KEY , 
            title TEXT, 
            description TEXT, 
            status TEXT, 
            priority TEXT, 
            createdDate TEXT 
          ) 
        ''');
      },
    );
    return _database!;
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'createdDate DESC');
    return maps.map((e) => Task.fromMap({
      'id': e['id'].toString() ?? '',  // Convert int id to String when mapping
      'title': e['title'].toString() ?? '',
      'description': e['description'].toString() ?? '',
      'status': e['status'].toString() ?? '',
      'priority': e['priority'].toString() ?? '',
      'createdDate': e['createdDate'].toString() ?? '',
    })).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Add this line
    );
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
