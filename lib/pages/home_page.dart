import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/lista_todo_controller.dart';
import '../models/todo.dart';
import '../repositories/todo_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var repo = TodoRepo();
  final listaTodosController = ListaTodoController();
  final todoController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _carregarTodos();
    super.initState();
  }

  Future<void> _carregarTodos() async {
    setState(() {
      isLoading = true;
    });
    await listaTodosController.pegarTodo();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                const Text('TODO-List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    )),
                const SizedBox(height: 50),
                TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Adicionar uma tarefa',
                    hintStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    prefixIcon: const Icon(Icons.add, color: Colors.white),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (todoController.text != '') {
                            listaTodosController.addTodo(Todo(
                              name: 'name',
                              description: todoController.text,
                              title: 'Todo - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            ));
                            todoController.text = '';
                            _carregarTodos();
                            setState(() {});
                          } else {
                            const SnackBar(
                              content: Text('Adicione uma tarefa'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            );
                          }
                        }),
                    contentPadding: const EdgeInsets.all(20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Obx(
                            () => ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey.shade400,
                                thickness: 1.1,
                              ),
                              itemCount: listaTodosController.todosList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Text(
                                    '🤐',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                  title: Text(
                                    listaTodosController.todosList[index].title.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    listaTodosController.todosList[index].description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade500,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Atenção'),
                                            content: const Text('Tem certeza que deseja apagar esta tarefa?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancelar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Apagar'),
                                                onPressed: () {
                                                  listaTodosController
                                                      .deleteTodo(listaTodosController.todosList[index]);
                                                  _carregarTodos();
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
