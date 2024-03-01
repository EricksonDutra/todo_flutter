class Todo {
  String name = '';
  String description = '';
  String title = '';
  String? objectId;

  Todo({required this.name, required this.description, required this.title});

  Todo.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['name'];
    description = json['description'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['name'] = name;
    data['description'] = description;
    data['title'] = title;
    return data;
  }
}
