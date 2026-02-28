import 'package:flutter/material.dart';
import 'package:postapp/model/todo_list_model.dart';
import 'package:postapp/services/network_caller.dart';
import 'package:postapp/services/network_response.dart';
import 'package:postapp/urls.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.todoListModel});
  final TodoListModel? todoListModel;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController titleTEController = TextEditingController();
  final TextEditingController descTEController = TextEditingController();

  bool _inProgress = false;

  bool get isUpdateTodo => widget.todoListModel != null;

  Future<void> createTask() async {
    setState(() {
      _inProgress = true;
    });

    final requestBody = {
      "title": titleTEController.text.trim(),
      "description": descTEController.text.trim(),
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createTodo,
      body: requestBody,
    );
    setState(() {
      _inProgress = false;
    });
    if (response.isSuccess) {
      _clearTextFields();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New task has been created....!')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.errorMessage)));
      }
    }
  }

  Future<void> updateTask() async {
    setState(() {
      _inProgress = true;
    });

    final requestBody = {
      "title": titleTEController.text.trim(),
      "description": descTEController.text.trim(),
    };
    final NetworkResponse response = await NetworkCaller.putRequest(
      url: Urls.updateTodo(id: widget.todoListModel!.sId.toString()),
      body: requestBody,
    );
    setState(() {
      _inProgress = false;
    });
    if (response.isSuccess) {
      _clearTextFields();
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Task has been updated")));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Task update failed")));
      }
    }
  }

  @override
  void initState() {
    if (isUpdateTodo) {
      titleTEController.text = widget.todoListModel!.title ?? '';
      descTEController.text = widget.todoListModel!.description ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdateTodo ? 'Update Task' : 'Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            TextFormField(
              controller: titleTEController,
              decoration: InputDecoration(
                label: Text('Title'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descTEController,
              decoration: InputDecoration(
                label: Text('Description'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 10),

            Visibility(
              visible: !_inProgress,
              replacement: Center(child: CircularProgressIndicator()),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    isUpdateTodo ? updateTask() :  createTask();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearTextFields() {
    titleTEController.clear();
    descTEController.clear();
  }
}
