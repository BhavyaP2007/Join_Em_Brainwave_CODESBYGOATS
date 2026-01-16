import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  Future<Database?> get database async{
    if(db != null){
      return db;
    }
    db = await getDataBase();
    return db;
  }
  Future<Database> getDataBase() async{
    final DatabaseDirPath = await getDatabasesPath();
    print(DatabaseDirPath);
    final DatabasePath = join(DatabaseDirPath,"master_db.db");
    final database = await openDatabase(DatabasePath,
    version: 2,
    onCreate: (db,version) async {
      await db.execute(
        """
        CREATE TABLE users(
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        employment_type TEXT,
        account_type TEXT NOT NULL

        );
        """
      );
      await db.execute(
        """
        CREATE TABLE competition(
        event_id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT NOT NULL,
            description TEXT NOT NULL,
            prizes TEXT NOT NULL,
            schedule TEXT NOT NULL,
            date_of_event TEXT NOT NULL,
            offline_online TEXT NOT NULL,
            venue TEXT NOT NULL,
            faqs TEXT NOT NULL,
            text_file TEXT NOT NULL,
            reviews TEXT NOT NULL,
            n_participants INTEGER NOT NULL,
            total_participants INTEGER NOT NULL,
            teams_data TEXT NOT NULL
            );
        """
      );
    },
   onUpgrade: (db, oldVersion, newVersion) async {
     if (oldVersion < 2) {
       await db.execute("""
          CREATE TABLE competition(
            event_id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT NOT NULL,
            description TEXT NOT NULL,
            prizes TEXT NOT NULL,
            schedule TEXT NOT NULL,
            date_of_event TEXT NOT NULL,
            offline_online TEXT NOT NULL,
            venue TEXT NOT NULL,
            faqs TEXT NOT NULL,
            text_file TEXT NOT NULL,
            reviews TEXT NOT NULL,
            n_participants INTEGER NOT NULL,
            total_participants INTEGER NOT NULL,
            teams_data TEXT NOT NULL
            );
        """);
     }
   });
    return database;
}

  void addUser(String? name,String? email,String? password,String? employment,String? account) async{
    final db_adduser = await database;
    await db_adduser?.insert("users", {
      "name":name,
      "email":email,
      "password":password,
      "employment_type":employment,
      "account_type":account,
    });
  }
  Future<bool?> userExists(String? email) async{
    final db_usercheck = await database;
    final result = await db_usercheck?.query("users",
      where: "email = ?",
      whereArgs: [email],
    );
    return result?.isNotEmpty;
  }
  void ClearUsers() async{
    final db_clear = await database;
    db_clear?.delete("users");
}
  Future<List<Map<String,Object?>>?> LoginUser(String? email,String? password) async{
    final db_login = await database;
    final user = await db_login?.query("users",
      where: "email = ? AND password = ?",
      whereArgs: [email,password]
    );
    return user;
  }
}