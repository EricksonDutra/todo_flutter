import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_flutter/models/todo.dart';

class TodoRepo {
  final dio = Dio();
  final Map<String, String> headers = {
    'X-Parse-Application-Id': dotenv.env['X-Parse-Application-Id'] as String,
    'X-Parse-REST-API-Key': dotenv.env['X-Parse-REST-API-Key'] as String,
    "Content-Type": "application/json"
  };
  final urlBase = 'https://parseapi.back4app.com/classes';

  Future<List<Todo>> getTodo() async {
    final res = await dio.get('$urlBase/todos', options: Options(headers: headers));
    if (res.statusCode == 200) {
      final List<dynamic> results = res.data['results'];
      final List<Todo> todoList = results.map((json) => Todo.fromJson(json)).toList();
      return todoList;
    } else {
      throw Exception(('Falha ao obter dados: ${res.statusCode}'));
    }
  }

  Future<void> apagarTodo(objectId) async {
    final res = await dio.delete('$urlBase/todos/$objectId', options: Options(headers: headers));
    if (res.statusCode != 200) {
      throw Exception(('Falha ao apagar dados: ${res.statusCode}'));
    }
  }

  Future<void> criarTodo(Todo todo) async {
    final res = await dio.post(
      '$urlBase/todos',
      data: todo.toJson(),
      options: Options(headers: headers),
    );
    if (res.statusCode != 201) {
      throw Exception('Falha ao criar dados: ${res.statusCode}');
    }
  }
}
