import 'package:flutter/material.dart';

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'To-do List App',
        todos: [],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.todos})
      : super(key: key);

  final String title;
  final List<Todo> todos;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  void _addTodo() {
    String text = _textEditingController.text;
    if (text.isNotEmpty) {
      setState(() {
        widget.todos.add(Todo(name: text, checked: false));
      });
      _textEditingController.clear();
    }
  }

  void _removeTodoAtIndex(int index) {
    setState(() {
      widget.todos.removeAt(index);
    });
  }

  void _toggleTodoAtIndex(int index) {
    setState(() {
      widget.todos[index].checked = !widget.todos[index].checked;
    });
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    final todo = widget.todos[index];

    return ListTile(
      leading: Checkbox(
        value: todo.checked,
        onChanged: (_) => _toggleTodoAtIndex(index),
      ),
      title: Text(todo.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeTodoAtIndex(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter a todo',
              contentPadding: EdgeInsets.all(8.0),
            ),
            onSubmitted: (_) {
              _addTodo();
              setState(() {});
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.todos.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      widget.todos.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task removed"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: _buildTodoItem(context, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
