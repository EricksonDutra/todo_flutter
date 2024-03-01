import 'package:get/get.dart';

import '../models/todo.dart';
import '../repositories/todo_repo.dart';

class ListaTodoController extends GetxController {
  List<Todo> get todosList => _todos.toList().obs();
  List<Todo> _todos = <Todo>[].obs();
  var repo = TodoRepo();

  pegarTodo() async {
    try {
      _todos = await repo.getTodo();
      update();
    } catch (e) {
      print('Erro ao carregar todos: $e');
    }
  }

  addTodo(Todo todo) async {
    await repo.criarTodo(todo);
    update();
  }

  deleteTodo(Todo todo) async {
    await repo.apagarTodo(todo.objectId);
    update();
  }
}
