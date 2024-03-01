import 'package:dio/dio.dart';
import 'package:todo_flutter/models/todo.dart';

class TodoRepo {
  final dio = Dio();
  final Map<String, String> headers = {
    "X-Parse-Application-Id": "6WgrSD7fVYFQNpycMYmF65BlfcTF1yTU9KNQVNzh",
    "X-Parse-REST-API-Key": "VKWEF9xDD61M3npLg7oIx6aNY2RgIs3P0gvFtouK",
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
