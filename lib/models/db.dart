import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mongo {
  static var db, coll, coll2;

  static connect() async {
    db = await Db.create(
        'mongodb+srv://root:_password@memes.2xsyj.mongodb.net/kando?retryWrites=true&w=majority');
    await db.open();
    coll = db.collection("tasks");
    coll2 = db.collection("users");
  }

  static insert(String text, int status, String user) async {
    var task = {
      "task": text,
      "status": status,
      "creator": user,
      "date": DateTime.now().toString(),
    };
    await coll.insert(task);
  }

  static update({required ObjectId id, required task, required status}) async {
    await coll.update({
      '_id': id
    }, {
      '\$set': {'task': task, 'status': status}
    });
  }

  static Future<List<Map<String, dynamic>>> getall(String username) async {
    try {
      List<Map<String, dynamic>> out =
          await coll.find({'creator': username}).toList();
      return out;
    } catch (e) {
      return Future.value();
    }
  }

  static Future<void> statusUpdate(ObjectId id) async {
    var out = await coll.find({'_id': id}).toList();
    int stat = out[0]['status'];
    stat++;
    await coll.update({
      '_id': id
    }, {
      '\$set': {'status': stat}
    });
  }

  static Future<void> delete(ObjectId id) async {
    await coll.remove({"_id": id});
  }

  static Future<Map<String, dynamic>> get(ObjectId id) async {
    try {
      var out = await coll.find({'_id': id}).toList();
      return out[0];
    } catch (e) {
      return Future.value();
    }
  }

  //user methods
  static Future<String> original(String username) async {
    try {
      List<dynamic> all = await coll2.find({'username': username}).toList();
      if (all.isEmpty) {
        return 'true';
      } else {
        return 'false';
      }
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<String> checkpass(String username, String password) async {
    try {
      var user = await coll2.find({'username': username}).toList();
      if (user[0]['password'] == password) {
        return 'true';
      } else {
        return 'false';
      }
    } catch (e) {
      return Future.value();
    }
  }

  static adduser(username, password, email) async {
    var user = {
      "username": username,
      "password": password,
      "email": email,
    };
    await coll2.insert(user);
  }
}

class SP {
  static var pref;

  static connect() async {
    pref = await SharedPreferences.getInstance();
  }
}

class Task {
  final ObjectId id;
  final String title;
  final int status;
  Task({required this.id, required this.title, required this.status});
  Task.fromJson(var json)
      : id = json['_id'],
        title = json['task'],
        status = json['status'];
}
