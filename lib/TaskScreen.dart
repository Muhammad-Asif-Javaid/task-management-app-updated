import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/login_screen.dart';
import 'package:task_management_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/task_provider.dart';

class Taskscreen extends StatefulWidget {
  const Taskscreen({super.key});

  @override
  State<Taskscreen> createState() => _TaskscreenState();
}

class _TaskscreenState extends State<Taskscreen> {

  final TextEditingController _controller = TextEditingController();
  final auth = FirebaseAuth.instance;

  // ADD TASK
  void _addTask() {
    if (_controller.text.trim().isEmpty) return;

    Provider.of<TaskProvider>(context, listen: false)
        .addTask(_controller.text.trim());

    _controller.clear();
  }

  // ADD TASK DIALOG
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Add New Task"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Enter task",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Task Manager",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddDialog,
          ),

          IconButton(
              onPressed: (){
                auth.signOut().then((value){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen())
                  );
                }).onError((error , stackTrace){
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined , color: Colors.white)
          ),

          const SizedBox(width: 10,)
        ],
      ),

      body: Container(
        color: Colors.grey.shade100,

        child: tasks.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt,
                  size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No tasks yet",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )

            : ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: tasks.length,

          itemBuilder: (context, index) {

            final task = tasks[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),

                leading: GestureDetector(

                  onTap: (){
                    taskProvider.toggleTask(index);
                  },

                  child: CircleAvatar(
                    backgroundColor: task['done']
                        ? Colors.green
                        : Colors.indigo,

                    child: Icon(
                      task['done']
                          ? Icons.check
                          : Icons.circle_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

                title: Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task['done']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.red),

                  onPressed: (){
                    taskProvider.deleteTask(index);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}